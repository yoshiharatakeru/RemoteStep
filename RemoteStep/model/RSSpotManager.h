//
//  RSSpotManager.h
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/07/06.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSpot.h"

@interface RSSpotManager : NSObject

@property (nonatomic,strong) NSMutableArray *spots;

+ (RSSpotManager*)sharedManager;
- (void)addSpot:(RSSpot*)spot;
- (void)removeSpotAtIndex:(int)index;
- (void)removeAllSpots;


@end
