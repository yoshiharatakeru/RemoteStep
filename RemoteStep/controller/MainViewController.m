//
//  MainViewController.m
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/06/13.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "MainViewController.h"
#import "RSLocations.h"

@interface MainViewController ()
{
    __weak IBOutlet MKMapView *_mapView1;
    __weak IBOutlet MKMapView *_mapView2;
    RSLocationManager *_manager;
    float _diff_x;
    float _diff_y;
    __weak IBOutlet UIButton *btClear;
    
    
}

@end

@implementation MainViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView1.delegate = self;
    _mapView2.delegate = self;
    
    //gesture
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMap:)];
    
    [_mapView1 addGestureRecognizer:ges];
    
    //model
    _manager = RSLocationManager.new;
    
    
    //button
    [btClear addTarget:self action:@selector(btClearPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [self updateDiff];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
