//
//  MainViewController.m
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/06/13.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "MainViewController.h"
#import "RSLocations.h"
#import "RSButton.h"
#import "GAITracker.h"
#import "GAI.h"
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
    float _distance;
    
    enum mapMode _mapMode;
    __weak IBOutlet UILabel *_lb_distance;
    
    
    //スペース初期値
    float _first_slider_topSpce;
    float _first_separator_topSpace;
    
    
    
    //constraint
    __weak IBOutlet NSLayoutConstraint *_slider_topSpace;
    __weak IBOutlet NSLayoutConstraint *_map1_height;
    
    __weak IBOutlet NSLayoutConstraint *_searchBar_topSpace;
    
    __weak IBOutlet NSLayoutConstraint *separator_topSpace;
    
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
    NSLog(@"bounds.height:%f",_searchBar.bounds.size.height);
    _searchBar_topSpace.constant = -44;
    _searchBar.showsCancelButton = YES;
    
    _distance = 0;
    
    
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self updateDiff];
    
    self.trackedViewName = @"MainView";
    

    
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
        _first_separator_topSpace = separator_topSpace.constant;
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
        
        //セパレータ移動
        separator_topSpace.constant = _first_separator_topSpace + translation.y;
           
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
    
    
    //距離の計算
    if (_manager.locations.count <= 1) {
        return;
    }
    
    RSLocation *previous = _manager.locations[_manager.locations.count-2];
    float dis = [self calculateDistanceFromLocation1:new_location.location toLocation2:previous.location];
    _distance += dis;
    
    _lb_distance.text = [NSString stringWithFormat:@"%.1fkm",_distance];



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

#pragma mark -
#pragma mark ListViewControllerDelegate

- (void)ListViewControllerDidCancelEditing:(id)sender{
    [sender dismissModalViewControllerAnimated:YES];
}


- (void)ListViewController:(ListViewController*)sender didSelectSpot:(RSSpot *)spot{
    
    [sender dismissViewControllerAnimated:YES completion:nil];
    
    MKMapView *mapView = (sender.map_num == 1)? _mapView1 : _mapView2;
    
    //map更新
    MKCoordinateRegion region = mapView.region;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake([spot.latitude floatValue], [spot.longitude floatValue]);
    
    region.center = center;
    region.span = MKCoordinateSpanMake(spot.span.floatValue, spot.span.floatValue);
    [mapView setRegion:region];
    
    [self btClearPressed:nil];
    
    
    
}

#pragma mark -
#pragma mark mapview delegate

- (MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    
    MKPolylineView *view = [[MKPolylineView alloc]initWithOverlay:overlay];
    view.strokeColor = [UIColor blueColor];
    view.lineWidth = 5.0;
    return view;
}

//縮尺変更時
/*
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    NSLog(@"region changed");
    
    @try {
        
        if (mapView.tag == 1) {
            MKCoordinateRegion region = _mapView2.region;
            NSLog(@"center.x:%f",region.center.latitude);
            NSLog(@"span:%f",region.span.latitudeDelta);
            
            region.span = MKCoordinateSpanMake(mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
            region.center  = _mapView2.region.center;
            [_mapView2 setRegion:region];
        }
        if (mapView.tag == 2) {
            MKCoordinateRegion region = _mapView1.region;
            region.span = MKCoordinateSpanMake(mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
            region.center = _mapView1.region.center;
            [_mapView1 setRegion:region];
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@",exception.reason);
    }

}
*/


#pragma mark -
#pragma mark button action
- (IBAction)listBtPressed:(UIButton*)bt {
    
    MKMapView *mapView;
    
    mapView = (bt.tag == 1)? _mapView1 : _mapView2;
    
    //現在の表示場所を取得
    RSSpot *currentSpot = RSSpot.new;
    NSString *lat, *lng, *point_x, *point_y, *span;
    
    lat = [NSString stringWithFormat:@"%f",mapView.centerCoordinate.latitude];
    lng = [NSString stringWithFormat:@"%f",mapView.centerCoordinate.longitude];
    
    MKMapPoint p = MKMapPointForCoordinate(_mapView1.centerCoordinate);
    point_x = [NSString stringWithFormat:@"%f",p.x];
    point_y = [NSString stringWithFormat:@"%f",p.y];
    
    span = [NSString stringWithFormat:@"%f",mapView.region.span.latitudeDelta];
    
    currentSpot.latitude  = lat;
    currentSpot.longitude = lng;
    currentSpot.point_x   = point_x;
    currentSpot.point_y   = point_y;
    currentSpot.span      = span;
    
    
    //リスト開く
    ListViewController *listCon = [self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
    listCon.delegate = self;
    listCon.map_num  = bt.tag;
    listCon.currentSpot = currentSpot;
    
    [self presentViewController:listCon animated:YES completion:nil];
    

}

- (void)btClearPressed:(UIButton*)bt{
    
    
    [_manager removeAllLocations];
    [_mapView1 removeOverlays:_mapView1.overlays];
    [_mapView2 removeOverlays:_mapView2.overlays];
    _distance = 0;
    _lb_distance.text = [NSString stringWithFormat:@"%f",_distance];
    
}
- (IBAction)searchBt1Pressed:(id)sender {
    
    _searchBar_topSpace.constant = 0;
    _mapMode = MAP_MODE_1;
    [_searchBar becomeFirstResponder];

}



- (IBAction)searchBt2Pressed:(id)sender {
    
    _searchBar_topSpace.constant = 0;
    _mapMode = MAP_MODE_2;
    [_searchBar becomeFirstResponder];
}


#pragma mark -
#pragma mark search bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    _searchBar_topSpace.constant = -44;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //tracking
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"MainView" withAction:@"searchLocation" withLabel:searchBar.text withValue:nil];
    
    
    [self.view endEditing:YES];
    _searchBar_topSpace.constant = -44;
    
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


- (float)calculateDistanceFromLocation1:(CLLocation*)location1 toLocation2:(CLLocation*)location2{
    
    
    //location1
    float lat1 = location1.coordinate.latitude;
    float lng1 = location1.coordinate.longitude;
    
    //location2
    float lat2 = location2.coordinate.latitude;
    float lng2 = location2.coordinate.longitude;
    
    //地球の半径
    float earth_r = 6378.137;
    
    //計算
    float diff_lat = M_PI/180*(lat2 - lat1);
    float diff_lng = M_PI/180*(lng2 - lng1);
    
    float dis_n_s = earth_r * diff_lat;
    float dis_e_w = cos(M_PI/180*lat1) * earth_r * diff_lng;
    
    float distance = sqrtf(pow(dis_e_w, 2) + pow(dis_n_s, 2));

    return distance;
    
}


@end
