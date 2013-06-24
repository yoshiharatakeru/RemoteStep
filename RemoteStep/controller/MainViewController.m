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
    
}

@end

@implementation MainViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView1.delegate = self;
    
    //gesture
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMap:)];
    
    [_mapView1 addGestureRecognizer:ges];
    
    //model
    _manager = RSLocationManager.new;
    

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//地図の際を更新


- (void)tapMap:(UITapGestureRecognizer*)sender{
    
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

    MKMapPoint points[_manager.locations.count];
    
    for (int i=0; i<_manager.locations.count; i++) {
        RSLocation *location = _manager.locations[i];
        
        points[i] = location.mapPoint;
    }
    
    MKPolyline *line = [MKPolyline polylineWithPoints:points count:_manager.locations.count];

    [_mapView1 addOverlay:line];
    
}


- (MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    
    MKPolylineView *view = [[MKPolylineView alloc]initWithOverlay:overlay];
    view.strokeColor = [UIColor blueColor];
    view.lineWidth = 5.0;
    return view;
}


@end
