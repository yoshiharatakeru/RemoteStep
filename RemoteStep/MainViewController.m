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
    RSLocations *_locations;
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
    
    //locations
    _locations = [[RSLocations alloc]init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tapMap:(UITapGestureRecognizer*)sender{
    
    CGPoint point = [sender locationInView:_mapView1];
    NSLog(@"スクリーン上の座標%f",point.x);
    
    CLLocationCoordinate2D coordinate = [_mapView1 convertPoint:point toCoordinateFromView:_mapView1];
    NSLog(@"座標:%f",coordinate.latitude);
    
    //cllocationで保存
    CLLocation *location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [_locations addLocation:location];
    
    
    //描画
    
    CLLocationCoordinate2D coords[_locations.locations.count];
    for (int i=0; i<_locations.locations.count; i++) {
        
        CLLocation *location = _locations.locations[i];
        coords[i] = location.coordinate;
        
    }
    
    MKPolyline *line = [MKPolyline polylineWithCoordinates:coords count:_locations.locations.count];
    
    [_mapView1 addOverlay:line];
    

}


- (MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    
    MKPolylineView *view = [[MKPolylineView alloc]initWithOverlay:overlay];
    view.strokeColor = [UIColor blueColor];
    view.lineWidth = 5.0;
    return view;
}


@end
