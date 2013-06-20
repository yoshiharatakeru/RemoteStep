//
//  RSLocations.h
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/06/13.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RSLocations : NSObject

@property(nonatomic,strong)NSMutableArray *locations;


- (void)addLocation:(CLLocation*)location;

@end
