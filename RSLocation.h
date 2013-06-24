//
//  RSLocation.h
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/06/20.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RSLocation : NSObject

@property (nonatomic,strong) CLLocation *location;
@property MKMapPoint mapPoint;


@end
