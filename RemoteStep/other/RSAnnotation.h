//
//  RSAnnotation.h
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/12/10.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RSAnnotation : NSObject <MKAnnotation>

@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) UIImage *image;


- (id)initWithLocationCoordinate:(CLLocationCoordinate2D)coordinate image:(UIImage*)image;

@end
