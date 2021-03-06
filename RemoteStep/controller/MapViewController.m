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
    __weak IBOutlet MKMapView *_mapView1;
    __weak IBOutlet MKMapView *_mapView2;
    __weak IBOutlet UIButton *_btDelete;
    __weak IBOutlet UISearchBar *_searchBar;
    __weak IBOutlet UIButton *_btn_black_view;
    __weak IBOutlet UIButton *_btn_map2;
    __weak IBOutlet UIButton *_btn_map1;
    __weak IBOutlet UIButton *_btn_switch;
    
    //model
    RSLocationManager *_locationManager;

    //constraint
    
    float _diff_x, _diff_y;
    float _distance;
    MKMapView *_selectedMap;
    UILabel   *_lb_distance;
    __weak IBOutlet NSLayoutConstraint *_rightSpace_btClear;
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

    //mapView
    _mapView1.delegate = self;
    _mapView2.delegate = self;
    
    MKCoordinateRegion region1 = _mapView1.region;
    region1.center = CLLocationCoordinate2DMake(35.683, 139.772);
    region1.span = MKCoordinateSpanMake(0.05, 0.05);
    
    MKCoordinateRegion region2 = _mapView2.region;
    region2.center = CLLocationCoordinate2DMake(40.771, -73.974);
    region2.span = MKCoordinateSpanMake(0.05, 0.05);
    
    [_mapView1 setRegion:region1];
    [_mapView2 setRegion:region2];
    
    //model
    _locationManager = [RSLocationManager new];
    
    //button_clear
    [_btDelete addTarget:self action:@selector(btDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
    _rightSpace_btClear.constant = _btDelete.bounds.size.width * -1;
    
    //search bar
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    _searchBar.alpha = 0;
    
    //最初はmap1が選択されている
    _selectedMap = _mapView2;
    [self btMap1Pressed:nil];
    
    //black_view
    [_btn_black_view addTarget:self action:@selector(btnBlackViewPressed) forControlEvents:UIControlEventTouchDown];
    
    //navigationBar
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:0.70 blue:0.95 alpha:1]];
    
    //title
    _lb_distance = [[UILabel alloc]initWithFrame:CGRectMake(50, 14, 150, 50)];
    _lb_distance.backgroundColor = [UIColor clearColor];
    _lb_distance.font = [UIFont boldSystemFontOfSize:23];
    _lb_distance.textColor = [UIColor whiteColor];
    _lb_distance.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView= _lb_distance;
    _lb_distance.text = @"0km";
    [_lb_distance sizeToFit];
    
    //status bar
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //button swithch mapType
    [_btn_switch addTarget:self action:@selector(btnSwitchPressed:) forControlEvents:UIControlEventTouchUpInside];
 
    
    
}



- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"isFirstLaunch!:%@",[ud objectForKey:@"isFirstLaunch"]);
    if ([[ud objectForKey:@"isFirstLaunch"]isEqualToString:@"NO"]) {
        return;
    }
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
    //EAIntroView test
    self.navigationController.navigationBarHidden = YES;
    EAIntroPage *page1 = [EAIntroPage page];
    UIImageView *iv1 = [[UIImageView alloc]initWithFrame:self.view.bounds];
    iv1.image = [UIImage imageNamed:@"intro_1_568"];
    page1.customView = iv1;
    
    EAIntroPage *page2 = [EAIntroPage page];
    UIImageView *iv2 = [[UIImageView alloc]initWithFrame:self.view.bounds];
    iv2.image = [UIImage imageNamed:@"intro_2_568"];
    page2.customView = iv2;
    
    EAIntroPage *page3 = [EAIntroPage page];
    UIImageView *iv3 = [[UIImageView alloc]initWithFrame:self.view.bounds];
    iv3.image = [UIImage imageNamed:@"intro_3_568"];
    page3.customView = iv3;
    
    EAIntroView *intro = [[EAIntroView alloc]initWithFrame:self.view.bounds andPages:@[page1, page2, page3]];
    intro.delegate = self;
    
    [intro showInView:self.view animateDuration:0.0];
    
    [ud setObject:@"NO" forKey:@"isFirstLaunch"];
    [ud synchronize];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark mapView delegate
- (MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    
    //line
    MKPolylineView *view = [[MKPolylineView alloc]initWithOverlay:overlay];
    view.fillColor = [UIColor colorWithHue:50 saturation:50 brightness:100 alpha:0.5];
    if (mapView == _mapView2) {//map2には破線で表示
        NSNumber *lineGapSize = [NSNumber numberWithInteger:10];
        view.lineDashPattern = [NSArray arrayWithObjects:lineGapSize,lineGapSize,nil];
    }
    
    view.strokeColor = [UIColor colorWithRed:0.95 green:0.38 blue:0.07 alpha:1.0];
    view.lineWidth = 5.0;
    return view;
    
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
#pragma mark ListViewControllerDelegate

- (void)ListViewControllerDidCancelEditing:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)ListViewController:(ListViewController*)sender didSelectSpot:(RSSpot *)spot{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    MKMapView *mapView = (sender.map_num == 1)? _mapView1 : _mapView2;
    
    //map更新
    MKCoordinateRegion region = mapView.region;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake([spot.latitude floatValue], [spot.longitude floatValue]);
    
    region.center = center;
    region.span = MKCoordinateSpanMake(spot.span.floatValue, spot.span.floatValue);
    [mapView setRegion:region];
    
    [self btDeletePressed:nil];
    
    
}


#pragma mark -
#pragma mark private action

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
    //クリアボタンの表示
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _rightSpace_btClear.constant = 0;
        [self.view layoutIfNeeded];
    } completion:nil];
    
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
    
    //_lb_distance.text = [NSString stringWithFormat:@"%.1fkm",_distance];
    _lb_distance.text = [NSString stringWithFormat:@"%.1fkm", _distance];
    
  
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
        RSAnnotation *annotation = [[RSAnnotation alloc]initWithLocationCoordinate:locationModel.location.coordinate image:[UIImage imageNamed:@"dot_red"]];
        [_mapView1 addAnnotation:annotation];
    }

    
    
    
    //mapView2
    MKMapPoint points2[_locationManager.locations.count];
    for (int i=0; i<_locationManager.locations.count;i++) {
        RSLocation *location = _locationManager.locations[i];
        points2[i] = MKMapPointMake(location.mapPoint.x+_diff_x, location.mapPoint.y+_diff_y);
    }
    
    MKPolyline *line2 = [MKPolyline polylineWithPoints:points2 count:_locationManager.locations.count];
    [_mapView2 addOverlay:line2];
    
    //annotation(dot)
    for (RSLocation *locationModel in _locationManager.locations) {
        
        RSAnnotation *annotation = [[RSAnnotation alloc]initWithMapPoint:MKMapPointMake(locationModel.mapPoint.x+_diff_x, locationModel.mapPoint.y+_diff_y) image:[UIImage imageNamed:@"dot_red"]];
        
        [_mapView2 addAnnotation:annotation];
        
        
    }
    
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


- (void)switchMap
{
    if (_selectedMap == _mapView1) {
        //switch to map2
        _selectedMap = _mapView2;
        _btn_map2.selected = YES;
        _btn_map1.selected = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            _mapView2.alpha = 1;
            _mapView2.userInteractionEnabled = YES;
            _mapView1.userInteractionEnabled = NO;
        }];
    }
    
    else{
        //switch to map1
        _selectedMap = _mapView1;
        _btn_map1.selected  = YES;
        _btn_map2.selected = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            _mapView2.alpha = 0;
            _mapView1.userInteractionEnabled = YES;
            _mapView2.userInteractionEnabled = NO;
        }];
    }
}


- (void)showSearchBar
{
    [UIView animateWithDuration:0.3 animations:^{
        _searchBar.alpha = 1;
        _btn_black_view.alpha = 1;
    } completion:^(BOOL finished) {
        [_searchBar becomeFirstResponder];
    }];
    
}


- (void)hideSearchBar
{
    [UIView animateWithDuration:0.3 animations:^{
        _searchBar.alpha = 0;
        _btn_black_view.alpha = 0;
    } completion:^(BOOL finished) {
        [_searchBar resignFirstResponder];
    }];
}


#pragma mark -
#pragma mark search bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self hideSearchBar];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //tracking
    /*
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"MainView" withAction:@"searchLocation" withLabel:searchBar.text withValue:nil];
     */
    
    
    [self hideSearchBar];
    
    //場所を検索
    //正ジオコーディングで場所の検索
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if (error) {
            NSLog(@"geocoder error:%@",error.localizedDescription);
        }
        
        if (placemarks.count >0){
            
            NSLog(@"num of places :%d",placemarks.count);
            
            CLPlacemark *placemark;
            placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            
            //マップの位置を変更
                [_selectedMap setRegion:MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.02, 0.02))];
            
        }else{
            NSString *message = @"結果がありません";
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [al show];
        }
        
    }];
}

#pragma mark -
#pragma EAIntroDelegate
- (void)introDidFinish:(EAIntroView *)introView
{
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}



#pragma mark
#pragma mark button action

- (void)btnBlackViewPressed
{
    [self hideSearchBar];
    
}

- (void)btDeletePressed:(UIButton*)bt
{
    //ボタン隠す
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _rightSpace_btClear.constant = _btDelete.bounds.size.width * -1;
        [self.view layoutIfNeeded];
    } completion:nil];
    
    [_locationManager removeAllLocations];
    
    //overlay
    [_mapView1 removeOverlays:_mapView1.overlays];
    [_mapView2 removeOverlays:_mapView2.overlays];
    
    //annotation
    [_mapView1 removeAnnotations:_mapView1.annotations];
    [_mapView2 removeAnnotations:_mapView2.annotations];

    _distance = 0;
    _lb_distance.text = @"0.0km";
    
}



- (IBAction)btMap1Pressed:(id)sender {
    
    if (_selectedMap == _mapView1) {
        return;
    }
    
    
    //switch map
    [self switchMap];
}




- (IBAction)btMap2Pressed:(id)sender {
    
    if (_selectedMap == _mapView2) {
        return;
    }
    
    //button appearancen
    
    //switch map
    [self switchMap];
}




- (IBAction)btListPressed:(id)sender {
    MKMapView *mapView = _selectedMap;
    
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
    listCon.map_num  = (_selectedMap == _mapView1)? 1 : 2;
    listCon.currentSpot = currentSpot;
    
    [self.navigationController pushViewController:listCon animated:YES];
}


- (IBAction)btSearchPressed:(id)sender {
    
    if ([_searchBar isFirstResponder]) {
        [self hideSearchBar];
        return;
    }
    
    else{
        [self showSearchBar];
    }
}


- (void)btnSwitchPressed:(UIButton*)bt
{
    if (_mapView1.mapType == MKMapTypeStandard) {
        _mapView1.mapType = MKMapTypeSatellite;
        _mapView2.mapType = MKMapTypeSatellite;
        bt.selected = YES;
    
    }else{
        _mapView1.mapType = MKMapTypeStandard;
        _mapView2.mapType = MKMapTypeStandard;
        bt.selected = NO;
    }
    
}



@end
