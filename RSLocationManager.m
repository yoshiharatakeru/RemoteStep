//
//  RSLocationManager.m
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/06/20.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "RSLocationManager.h"

@implementation RSLocationManager

- (id)init{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _locations = NSMutableArray.new;
    
    return self;
}

//ここつくってるよ
- (void)addLocation:(RSLocation*)location{
    
    if (!location) {
        return;
    }
    
    [_locations addObject:location];
    
}


- (void)removeLocationAtIndex:(NSInteger)index{
    
    [_locations removeObjectAtIndex:index];
}


- (void)removeAllLocations{
    
    [_locations removeAllObjects];
}




@end
