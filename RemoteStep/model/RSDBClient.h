//
//  RSDBClient.h
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/07/02.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSpot.h"

@interface RSDBClient : NSObject

@property(nonatomic,strong) NSString *dbPath;

+ (RSDBClient*)sharedInstance;
- (void)createTable;
- (void)deleteTable;
- (void)createDBFile;
- (void)insertSpot:(RSSpot*)spot;
- (void)deleteSpot:(RSSpot*)spot;
- (NSArray*)selectAllSpots;




@end
