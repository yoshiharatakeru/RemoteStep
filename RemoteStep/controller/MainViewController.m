//
//  MainViewController.m
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/06/13.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "MainViewController.h"
#import "RSLocations.h"
enum mapMode {MAP_MODE_1, MAP_MODE_2} _mapMode;

@interface MainViewController ()
{
    __weak IBOutlet MKMapView *_mapView1;
    __weak IBOutlet MKMapView *_mapView2;
    RSLocationManager *_manager;
    float _diff_x;
    float _diff_y;
    __weak IBOutlet UIButton *btClear;
    __weak IBOutlet UIButton *_btDrag;
    BOOL _isBtDragging;
    __weak IBOutlet UISearchBar *_searchBar;
    
    enum mapMode _mapMode;
    
    //constraint
    __weak IBOutlet NSLayoutConstraint *_slider_topSpace;
    float _first_slider_topSpce;
    __weak IBOutlet NSLayoutConstraint *_map1_height;
    
}

@end

@implementation MainViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView1.delegate = self;
    _mapView2.delegate = self;
    
    //tap gesture
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMap:)];
    [_mapView1 addGestureRecognizer:ges];
    
    
    //drag gesture
    _isBtDragging = NO;
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(btDragged:)];
    [self.view addGestureRecognizer:panGes];
    _isBtDragging = NO;
    
    
    //model
    _manager = RSLocationManager.new;
    
    
    //button
    [btClear addTarget:self action:@selector(btClearPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //search bar
    _searchBar.delegate =self;
    
    
}


- (void)viewDidAppear:(BOOL)animated{
    
    [self updateDiff];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark private method

//地図のサイズを変更
- (void)btDragged:(UIPanGestureRecognizer*)ges{
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        _first_slider_topSpce = _slider_topSpace.constant;
        _isBtDragging = YES;

    }
    
    if (ges.state == UIGestureRecognizerStateEnded) {
        
        if (!_isBtDragging) {
            return;
        }
        
        //mapの移動
        _map1_height.constant = _btDrag.center.y;
        
        _isBtDragging = NO;
    }
    
    
    else{
        
        CGPoint translation = [ges translationInView:self.view];
        CGPoint location    = [ges locationInView:self.view];
        
        if (!_isBtDragging) {
            return;
        }
        
        if (location.y < _btDrag.bounds.size.height/2 || location.y > self.view.bounds.size.height - _btDrag.bounds.size.height/2) {
            return;
        }

        
        //スライダ移動
        _slider_topSpace.constant = _first_slider_topSpce + translation.y;
           
        [self.view layoutIfNeeded];
        
    }
    

    
    
}

//地図の差異を更新
- (void)updateDiff{
    
    MKMapPoint p1 = MKMapPointForCoordinate(_mapView1.centerCoordinate);
    MKMapPoint p2 = MKMapPointForCoordinate(_mapView2.centerCoordinate);
    
    _diff_x = p2.x - p1.x;
    _diff_y = p2.y - p1.y;
    
}


- (void)tapMap:(UITapGestureRecognizer*)sender{
    
    //最初のタップなら座標の差異を更新
    if (_manager.locations.count == 0) {
        [self updateDiff];
    }
    
    CGPoint point = [sender locationInView:_mapView1];
    NSLog(@"スクリーン上の座標%f",point.x);
    
    CLLocationCoordinate2D coordinate = [_mapView1 convertPoint:point toCoordinateFromView:_mapView1];
    NSLog(@"座標:%f",coordinate.latitude);
    
    //cllocation型
    CLLocation *location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    //MKMapPoint型
    MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
    NSLog(@"MKMapPoint:%f,%f",mapPoint.x,mapPoint.y);
    
    //RSLocation作成
    RSLocation *new_location = RSLocation.new;
    [new_location setLocation:location];
    [new_location setMapPoint:mapPoint];
    
    [_manager addLocation:new_location];

    [self prepareDrawing];
    


}


- (void)prepareDrawing{
    
    //描画

    //mapView1
    MKMapPoint points[_manager.locations.count];
    
    for (int i=0; i<_manager.locations.count; i++) {
        RSLocation *location = _manager.locations[i];
        
        points[i] = location.mapPoint;
    }
    
    MKPolyline *line = [MKPolyline polylineWithPoints:points count:_manager.locations.count];
    [_mapView1 addOverlay:line];
    
    
    //mapView2
    MKMapPoint points2[_manager.locations.count];
    for (int i=0; i<_manager.locations.count;i++) {
        RSLocation *location = _manager.locations[i];
        points2[i] = MKMapPointMake(location.mapPoint.x+_diff_x, location.mapPoint.y+_diff_y);
    }
    
    MKPolyline *line2 = [MKPolyline polylineWithPoints:points2 count:_manager.locations.count];
    [_mapView2 addOverlay:line2];
    
    
    
}


- (MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    
    MKPolylineView *view = [[MKPolylineView alloc]initWithOverlay:overlay];
    view.strokeColor = [UIColor blueColor];
    view.lineWidth = 5.0;
    return view;
}



#pragma mark -
#pragma mark button action

- (void)btClearPressed:(UIButton*)bt{
    
    [_manager removeAllLocations];
    [_mapView1 removeOverlays:_mapView1.overlays];
    [_mapView2 removeOverlays:_mapView2.overlays];
    
}
- (IBAction)searchBt1Pressed:(id)sender {
    
    _mapMode = MAP_MODE_1;
    [_searchBar becomeFirstResponder];

}



- (IBAction)searchBt2Pressed:(id)sender {
    
    _mapMode = MAP_MODE_2;
    [_searchBar becomeFirstResponder];
}


#pragma mark -
#pragma mark search bar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.view endEditing:YES];
    
    //場所を検索
    //正ジオコーディングで場所の検索
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error) {
            NSLog(@"geocoder error:%@",error.localizedDescription);
        }
        
        if (placemarks.count >0){
            
            NSLog(@"num of places :%d",placemarks.count);
            
            CLPlacemark *placemark;
            placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            
            //マップの位置を変更
            if (_mapMode == MAP_MODE_1) {
                [_mapView1 setRegion:MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.02, 0.02))];

            }else{
                [_mapView2 setRegion:MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.02, 0.02))];
            }
        
        }else{
            NSString *message = @"結果がありません";
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [al show];
        }
        
    }];
    
}



@end
