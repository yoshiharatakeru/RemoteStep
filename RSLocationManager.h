//
//  RSLocationManager.h
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/06/20.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSLocation.h"

@interface RSLocationManager : NSObject

@property(nonatomic,strong)NSMutableArray *locations;

- (void)addLocation:(RSLocation*)location;
- (void)removeLocationAtIndex:(NSInteger)index;
- (void)removeAllLocations;

@end
