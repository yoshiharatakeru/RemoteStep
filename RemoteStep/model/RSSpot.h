//
//  RSSpot.h
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/07/05.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSpot : NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *identifier;
@property(nonatomic,strong) NSString *latitude;
@property(nonatomic,strong) NSString *longitude;
@property(nonatomic,strong) NSString *point_x;
@property(nonatomic,strong) NSString *point_y;

@end
