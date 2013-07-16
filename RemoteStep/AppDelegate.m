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
    NSDictionary   *info = @{@"isFirstLaunch":@"YES"};
    [ud registerDefaults:info];
    
    if ([[ud objectForKey:@"isFirstLaunch"]isEqualToString:@"NO"]) {
        return;
    }
    
    //デフォルトのロケーションを登録
    
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
    
    RSDBClient *client = [RSDBClient sharedInstance];
    [client createTable];
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
    
    [ud setObject:@"NO" forKey:@"isFirstLaunch"];
    [ud synchronize];
    
    
    
    [ud setObject:@"NO" forKey:@"isFirstLaunch"];
    [ud synchronize];
    
    
 
    
    
}

@end
