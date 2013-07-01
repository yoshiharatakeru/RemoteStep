//
//  MainViewController.h
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/06/13.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RSLocation.h"
#import "RSLocationManager.h"

@interface MainViewController : UIViewController
<MKMapViewDelegate,UISearchBarDelegate>

@end
