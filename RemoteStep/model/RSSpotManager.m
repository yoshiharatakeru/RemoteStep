//
//  RSSpotManager.m
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/07/06.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "RSSpotManager.h"

static RSSpotManager *_sharedManager = nil;
@implementation RSSpotManager

+ (RSSpotManager*)sharedManager{
    
    if (_sharedManager == nil) {
        _sharedManager = RSSpotManager.new;
        _sharedManager.spots = NSMutableArray.new;
           
    }
    
    return _sharedManager;
    
}



+ (id)allocWithZone:(NSZone *)zone{
    
    @synchronized(self){
        if (_sharedManager == nil) {
            _sharedManager = [super allocWithZone:zone];
            return _sharedManager;
        }
    }
    return nil;
}



- (id)copyWithZone:(NSZone*)zone{
    return self;
}


- (void)addSpot:(RSSpot*)spot{
    
    if (!spot) {
        return;
    }
    
    [_spots addObject:spot];
    
    
}


-(void)removeSpotAtIndex:(int)index{
    
    NSLog(@"remove index:%d",index);

    [_spots removeObjectAtIndex:index];
}


- (void)removeAllSpots{
    
    [_spots removeAllObjects];
    
}


- (void)refreshSpots
{
    [self removeAllSpots];
    RSDBClient *client = [RSDBClient sharedInstance];
    NSMutableArray *spots = (NSMutableArray*)[client selectAllSpots];
    _spots = [spots mutableCopy];
    
}

@end
