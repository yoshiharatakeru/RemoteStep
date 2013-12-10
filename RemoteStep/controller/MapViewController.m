//
//  MapViewController.m
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/12/07.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
{
    //outlet
    __weak IBOutlet UISlider *_slider;
    __weak IBOutlet MKMapView *_mapView1;
    __weak IBOutlet MKMapView *_mapView2;
    __weak IBOutlet UILabel *_lb_distance;
    __weak IBOutlet UIButton *_btDelete;
    
    RSLocationManager *_locationManager;
    float _diff_x, _diff_y;
    float _distance;
    
}

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //tap gesture
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMap:)];
    [_mapView1 addGestureRecognizer:ges];
    
    //slider
    _slider.minimumValue = 0;
    _slider.maximumValue = 1;
    _slider.value = 0.5f;
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //mapView
    _mapView1.delegate = self;
    _mapView2.delegate = self;
    _mapView2.alpha = _slider.value;
    
    //model
    _locationManager = [RSLocationManager new];
    
    //button
    _btDelete.alpha = 0;
    [_btDelete addTarget:self action:@selector(btDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //search bar
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark mapView delegate
- (MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {//line
        
        MKPolylineView *view = [[MKPolylineView alloc]initWithOverlay:overlay];
        NSNumber *lineGapSize = [NSNumber numberWithInteger:10];
        view.fillColor = [UIColor colorWithHue:50 saturation:50 brightness:100 alpha:0.5];
        view.lineDashPattern = [NSArray arrayWithObjects:lineGapSize,lineGapSize,nil];
        view.strokeColor = [UIColor darkGrayColor];
        view.lineWidth = 5.0;
        return view;
    
    }else if ([overlay isKindOfClass:[MKCircle class]]){//circle
        
        MKCircleView *view = [[MKCircleView alloc]initWithOverlay:overlay];
        view.fillColor = [UIColor colorWithHue:50 saturation:50 brightness:50 alpha:1];
        return view;
    }
    
    return nil;

}


- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(RSAnnotation*)annotation
{
    MKAnnotationView *annotationView;
    annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"dot1"];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"dot1"];

    }
    
    annotationView.image = annotation.image;
    
    return annotationView;
    
}


#pragma mark -
#pragma mark private method

- (void)sliderValueChanged:(UISlider*)slider
{
    _mapView2.alpha = slider.value;
    [self switchMapUserInteraction];

    
}


//地図1と地図2の差の値を更新
- (void)updateDiff
{
    MKMapPoint p1 = MKMapPointForCoordinate(_mapView1.centerCoordinate);
    MKMapPoint p2 = MKMapPointForCoordinate(_mapView2.centerCoordinate);
    
    _diff_x = p2.x - p1.x;
    _diff_y = p2.y - p1.y;
    
}


- (void)tapMap:(UITapGestureRecognizer*)sender
{
    
    //縮尺を合わせる
    _mapView2.userInteractionEnabled = YES;
    MKCoordinateRegion region = _mapView2.region;
    region.span = _mapView1.region.span;
    [_mapView2 setRegion:region animated:NO];
    _mapView2.userInteractionEnabled = NO;
     
    
    if (_mapView2.userInteractionEnabled) {
        NSLog(@"YES");
    }
    
    //最初のタップなら座標の差異を更新
    if (_locationManager.locations.count == 0) {
        [self updateDiff];
    }
    
    //tapした座標を位置情報に変換
    CGPoint point = [sender locationInView:_mapView1];
    NSLog(@"スクリーン上の座標%f",point.x);
    
    CLLocationCoordinate2D coordinate = [_mapView1 convertPoint:point toCoordinateFromView:_mapView1];
    NSLog(@"座標:%f",coordinate.latitude);
    
    //cllocationとMKMapPointの値をRSLocationとして格納
    
    //cllocation型
    CLLocation *location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    //MKMapPoint型
    MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
    NSLog(@"MKMapPoint:%f,%f",mapPoint.x,mapPoint.y);
    
    //RSLocation作成
    RSLocation *new_location = RSLocation.new;
    [new_location setLocation:location];
    [new_location setMapPoint:mapPoint];
    
    [_locationManager addLocation:new_location];
    
    [self prepareDrawing];
    
    
    //距離の計算
    if (_locationManager.locations.count <= 1) {
        return;
    }
    
    RSLocation *previous = _locationManager.locations[_locationManager.locations.count-2];
    float dis = [self calculateDistanceFromLocation1:new_location.location toLocation2:previous.location];
    _distance += dis;
    
    _lb_distance.text = [NSString stringWithFormat:@"%.1fkm",_distance];
    
    
    //クリアボタン表示
    [UIView animateWithDuration:0.3 animations:^{
        _btDelete.alpha = 1;
    }];
    
    


}


- (void)prepareDrawing{
    
    //mapView1
    
    //クリア
    [_mapView1 removeAnnotations:_mapView1.annotations];
    [_mapView1 removeOverlays:_mapView1.overlays];
    
    //line
    MKMapPoint points[_locationManager.locations.count];
    
    for (int i=0; i<_locationManager.locations.count; i++) {
        RSLocation *location = _locationManager.locations[i];
        
        points[i] = location.mapPoint;
    }
    
    MKPolyline *line = [MKPolyline polylineWithPoints:points count:_locationManager.locations.count];
    [_mapView1 addOverlay:line];
    
    
    //annotation(dot)
    for (RSLocation *locationModel in _locationManager.locations) {
        RSAnnotation *annotation = [[RSAnnotation alloc]initWithLocationCoordinate:locationModel.location.coordinate image:[UIImage imageNamed:@"dot1"]];
        [_mapView1 addAnnotation:annotation];
    }
    
    /*
    //annotation(distance)
    RSLocation *latestLocation = [_locationManager.locations lastObject];
    RSAnnotation *annotation_distance = [[RSAnnotation alloc]initWithLocationCoordinate:latestLocation.location.coordinate image:[UIImage imageNamed:@"distance"]];
    [_mapView1 addAnnotation:annotation_distance];
     */
    
    
    
    
    //mapView2
    MKMapPoint points2[_locationManager.locations.count];
    for (int i=0; i<_locationManager.locations.count;i++) {
        RSLocation *location = _locationManager.locations[i];
        points2[i] = MKMapPointMake(location.mapPoint.x+_diff_x, location.mapPoint.y+_diff_y);
    }
    
    MKPolyline *line2 = [MKPolyline polylineWithPoints:points2 count:_locationManager.locations.count];
    [_mapView2 addOverlay:line2];
    
}


//マップの操作権をスイッチ
- (void)switchMapUserInteraction
{
    if ([self selectedMap] == _mapView1) {
        _mapView1.userInteractionEnabled = YES;
        _mapView2.userInteractionEnabled = NO;
    }
    
    else{
        _mapView1.userInteractionEnabled = NO;
        _mapView2.userInteractionEnabled = YES;
    }
}


- (MKMapView*)selectedMap
{
    if (_slider.value <= 0.5f) {
        return _mapView1;
    }
    
    return _mapView2;
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


#pragma mark
#pragma mark button action

- (void)btDeletePressed:(UIButton*)bt
{
    [_locationManager removeAllLocations];
    
    //overlay
    [_mapView1 removeOverlays:_mapView1.overlays];
    [_mapView2 removeOverlays:_mapView2.overlays];
    
    //annotation
    [_mapView1 removeAnnotations:_mapView1.annotations];
    [_mapView2 removeAnnotations:_mapView2.annotations];

    
    _distance = 0;
    _lb_distance.text = [NSString stringWithFormat:@"%f",_distance];
    
    _btDelete.alpha = 0;
}

@end
