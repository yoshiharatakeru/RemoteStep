//
//  RSAnnotation.m
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/12/10.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "RSAnnotation.h"

@implementation RSAnnotation

- (id)initWithLocationCoordinate:(CLLocationCoordinate2D)coordinate image:(UIImage *)image
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _image = image;
    _coordinate = coordinate;
    
    return self;
    
}

- (id)initWithMapPoint:(MKMapPoint)point image:(UIImage*)image
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _image = image;
    _coordinate = MKCoordinateForMapPoint(point);
    
    return self;
    
}

@end
