//
//  RSLocations.m
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/06/13.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "RSLocations.h"

@implementation RSLocations

- (id)init{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _locations = NSMutableArray.new;
    
    return self;
}


- (void)addLocation:(CLLocation*)location{
    
    if (!location) {
        return;
    }
    
    [_locations addObject:location];
         
}

@end
