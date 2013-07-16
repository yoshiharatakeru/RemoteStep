//
//  ListViewController.m
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/07/02.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//



#import "ListViewController.h"
#import "RSDBClient.h"
#import "RSSpotManager.h"   
#import "RSButton.h"
#import "GAI.h"
#import "GAITracker.h"

@interface ListViewController (){
    
    __weak IBOutlet UITableView *_tableView;
    UIAlertView *_al;
    UITextField *textField;
    RSSpotManager *_spotManager;
    
    
}

@end

@implementation ListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //tableview
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    //alertview
    [self initAlertView];
    
    //保存内容取得
    _spotManager = [RSSpotManager sharedManager];
    [_spotManager removeAllSpots];
    RSDBClient *client = [RSDBClient sharedInstance];
    NSMutableArray *spots = (NSMutableArray*)[client selectAllSpots];
    _spotManager.spots = [spots mutableCopy];
    
    
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    self.trackedViewName = @"ListView";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _spotManager.spots.count;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
    }
    

    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
    
}

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    
    RSSpot *spot = _spotManager.spots[indexPath.row];
    
    //名前
    UILabel *lb_name = (UILabel*)[cell viewWithTag:1];
    lb_name.text = spot.name;
    
    //地図
    MKMapView *mapView = (MKMapView*)[cell viewWithTag:2];
    mapView.mapType = MKMapTypeSatellite;

    float lat = [spot.latitude floatValue];
    float lng = [spot.longitude floatValue];
    
    MKCoordinateRegion region = mapView.region;
    region.center = CLLocationCoordinate2DMake(lat, lng);
    region.span.latitudeDelta = 0.2;
    region.span.longitudeDelta = 0.2;
    [mapView setRegion:region animated:NO];
    
    //削除ボタン
    RSButton *bt_rem = (RSButton*)[cell viewWithTag:3];
    bt_rem.indexPath = indexPath;
    [bt_rem addTarget:self action:@selector(removeSpot:) forControlEvents:UIControlEventTouchUpInside];
    
      
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate ListViewController:self didSelectSpot:_spotManager.spots[indexPath.row]];
    
    
}

#pragma mark -
#pragma mark button action

- (IBAction)cancelBtPressed:(id)sender {
    
    [_delegate ListViewControllerDidCancelEditing:self];
}


- (IBAction)addBtPressed:(id)sender {
    
    [_al show];
    
    
}


- (void)removeSpot:(RSButton*)bt{

    
    RSDBClient *client = [RSDBClient sharedInstance];
    
    //DBから消去
    [client deleteSpot:_spotManager.spots[bt.indexPath.row]];
    
    //テーブルから消去
    [_spotManager removeSpotAtIndex:bt.indexPath.row];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:bt.indexPath.row inSection:0];
    NSLog(@"indexpath.row:%d",bt.indexPath.row);
    NSLog(@"cout:%d",_spotManager.spots.count);
    NSLog(@"numberofcells:%d",[_tableView numberOfRowsInSection:0]);
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    //テーブル更新
    for (int i = 0; i < _spotManager.spots.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [self updateCell:cell atIndexPath:indexPath];
    }
    
    
    
}



#pragma mark -
#pragma mark private action

- (void)initAlertView{
    
    _al = [[UIAlertView alloc]initWithTitle:@"現在地の保存" message:@" " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    // UITextFieldの生成
    textField = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 30)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textAlignment = UITextAlignmentLeft;
    textField.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    textField.textColor = [UIColor grayColor];
    textField.minimumFontSize = 8;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    textField.placeholder = @"場所の名前を入力";
    
    // アラートビューにテキストフィールドを埋め込む
    [_al addSubview:textField];
    
    
}


#pragma mark -
#pragma mark alertview

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex != 1) {
        return;
    }
    
    [self.view endEditing:YES];
    [_currentSpot setName:textField.text];
    
    //tracking
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSString *savedLocation = [NSString stringWithFormat:@"name:%@ lat:%@ lng:%@",_currentSpot.name, _currentSpot.latitude, _currentSpot.longitude];
    [tracker sendEventWithCategory:@"ListView" withAction:@"saveLocation" withLabel:savedLocation withValue:nil];
    
    
    //保存
    //DB
    RSDBClient *client = [RSDBClient sharedInstance];
    [client createTable];
    [client insertSpot:_currentSpot];
    
    //table
    [_spotManager addSpot:_currentSpot];
    
    int index;
    if (_spotManager.spots.count == 1 || _spotManager.spots.count == 2) {
        index = _spotManager.spots.count -  1;
    }else{
        index = _spotManager.spots.count - 1;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];

     
    //テーブル更新
    for (int i = 0; i < _spotManager.spots.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [self updateCell:cell atIndexPath:indexPath];
    }
    
     
}

@end
