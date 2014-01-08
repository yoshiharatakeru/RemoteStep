//
//  AppDelegate.m
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/06/13.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "AppDelegate.h"
#import "GAI.h"
#import "RSSpot.h"
#import "RSDBClient.h"
#import <MapKit/MapKit.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //初回起動であることを登録
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = @{ @"isFirstLaunch" : @"YES" };
    [ud registerDefaults:dic];
    
    //tracking 準備
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [GAI sharedInstance].debug = YES;
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41355170-2"];
    
    [self setDefaultLocations];
     

    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (void)setDefaultLocations{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([[ud objectForKey:@"isFirstLaunch"]isEqualToString:@"NO"]) {
        return;
    }
    
    //デフォルトのロケーションを登録
    RSDBClient *client = [RSDBClient sharedInstance];
    [client createTable];
    
    
    //ナスカの地上絵
    RSSpot *nazca = RSSpot.new;
    float lat_nazca = -14.692139;
    float lng_nazca = -75.148885;
    
    CLLocationCoordinate2D coor_nazca = CLLocationCoordinate2DMake(lat_nazca, lng_nazca);
    MKMapPoint point_nazca = MKMapPointForCoordinate(coor_nazca);
    
    NSString *span_nazca = @"0.005";
    
    nazca.latitude  = [NSString stringWithFormat:@"%f",lat_nazca];
    nazca.longitude = [NSString stringWithFormat:@"%f", lng_nazca];
    nazca.point_x   = [NSString stringWithFormat:@"%f", point_nazca.x];
    nazca.point_y   = [NSString stringWithFormat:@"%f", point_nazca.y];
    nazca.span      = span_nazca;
    nazca.name      = @"ナスカの地上絵";
    [client insertSpot:nazca];
    
    
    //ピラミッド
    RSSpot *pyramid = RSSpot.new;
    float lat_pyramid = 29.976524;
    float lng_pyramid = 31.130633;
    
    CLLocationCoordinate2D coor_pyramid = CLLocationCoordinate2DMake(lat_pyramid, lng_pyramid);
    MKMapPoint point_pyramid = MKMapPointForCoordinate(coor_pyramid);
    
    NSString *span_pyramid = @"0.005";
    
    pyramid.latitude  = [NSString stringWithFormat:@"%f",lat_pyramid];
    pyramid.longitude = [NSString stringWithFormat:@"%f", lng_pyramid];
    pyramid.point_x   = [NSString stringWithFormat:@"%f", point_pyramid.x];
    pyramid.point_y   = [NSString stringWithFormat:@"%f", point_pyramid.y];
    pyramid.span      = span_pyramid;
    pyramid.name      = @"ギザの3大ピラミッド";
    [client insertSpot:pyramid];
    
    
    //エアーズロック
    RSSpot *airsRock = RSSpot.new;
    float lat_airsrock = -25.3482961366005;
    float lng_airsrock = 131.0379157419216;
    
    CLLocationCoordinate2D coor_airsrock = CLLocationCoordinate2DMake(lat_airsrock, lng_airsrock);
    MKMapPoint point_airsrock = MKMapPointForCoordinate(coor_airsrock);
    
    NSString *span_airsrock = @"0.005";
    
    airsRock.latitude  = [NSString stringWithFormat:@"%f",lat_airsrock];
    airsRock.longitude = [NSString stringWithFormat:@"%f", lng_airsrock];
    airsRock.point_x   = [NSString stringWithFormat:@"%f", point_airsrock.x];
    airsRock.point_y   = [NSString stringWithFormat:@"%f", point_airsrock.y];
    airsRock.span      = span_airsrock;
    airsRock.name      = @"エアーズロック";
    [client insertSpot:airsRock];
    
    
    //パリ
    RSSpot *paris = RSSpot.new;
    float lat_paris = 48.8549;
    float lng_paris = 2.3471;
    
    CLLocationCoordinate2D coor_paris = CLLocationCoordinate2DMake(lat_paris, lng_paris);
    MKMapPoint point_paris = MKMapPointForCoordinate(coor_paris);
    
    NSString *span_paris = @"0.005";
    
    paris.latitude  = [NSString stringWithFormat:@"%f",lat_paris];
    paris.longitude = [NSString stringWithFormat:@"%f", lng_paris];
    paris.point_x   = [NSString stringWithFormat:@"%f", point_paris.x];
    paris.point_y   = [NSString stringWithFormat:@"%f", point_paris.y];
    paris.span      = span_paris;
    paris.name      = @"パリ";
    [client insertSpot:paris];
    
    
    //ロンドン
    RSSpot *london = RSSpot.new;
    float lat_london = 51.5107;
    float lng_london = -0.1197;
    
    CLLocationCoordinate2D coor_london = CLLocationCoordinate2DMake(lat_london, lng_london);
    MKMapPoint point_london = MKMapPointForCoordinate(coor_london);
    
    NSString *span_london = @"0.005";
    
    london.latitude  = [NSString stringWithFormat:@"%f",lat_london];
    london.longitude = [NSString stringWithFormat:@"%f", lng_london];
    london.point_x   = [NSString stringWithFormat:@"%f", point_london.x];
    london.point_y   = [NSString stringWithFormat:@"%f", point_london.y];
    london.span      = span_london;
    london.name      = @"ロンドン";
    [client insertSpot:london];
    
    
    //東京
    RSSpot *tokyo = RSSpot.new;
    float lat_tokyo = 35.689295;
    float lng_tokyo = 139.691835;
    
    CLLocationCoordinate2D coor_tokyo = CLLocationCoordinate2DMake(lat_tokyo, lng_tokyo);
    MKMapPoint point_tokyo = MKMapPointForCoordinate(coor_tokyo);
    
    NSString *span_tokyo = @"0.005";
    
    tokyo.latitude  = [NSString stringWithFormat:@"%f",lat_tokyo];
    tokyo.longitude = [NSString stringWithFormat:@"%f", lng_tokyo];
    tokyo.point_x   = [NSString stringWithFormat:@"%f", point_tokyo.x];
    tokyo.point_y   = [NSString stringWithFormat:@"%f", point_tokyo.y];
    tokyo.span      = span_tokyo;
    tokyo.name      = @"東京";
    [client insertSpot:tokyo];
    
    
    //ニューヨーク
    RSSpot *ny = RSSpot.new;
    float lat_ny = 40.765694;
    float lng_ny = -73.977220;
    
    CLLocationCoordinate2D coor_ny = CLLocationCoordinate2DMake(lat_ny, lng_ny);
    MKMapPoint point_ny = MKMapPointForCoordinate(coor_ny);
    
    NSString *span_ny = @"0.005";
    
    ny.latitude  = [NSString stringWithFormat:@"%f",lat_ny];
    ny.longitude = [NSString stringWithFormat:@"%f", lng_ny];
    ny.point_x   = [NSString stringWithFormat:@"%f", point_ny.x];
    ny.point_y   = [NSString stringWithFormat:@"%f", point_ny.y];
    ny.span      = span_ny;
    ny.name      = @"ニューヨーク";
    [client insertSpot:ny];
    
}


@end
