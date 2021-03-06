//
//  ListViewController.h
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/07/02.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

@protocol ListViewControllerDelegate;

#import <UIKit/UIKit.h>
#import "RSSpot.h"
#import <MapKit/MapKit.h>
#import "GAITrackedViewController.h"

@interface ListViewController : GAITrackedViewController
<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic,weak) id delegate;
@property (nonatomic,strong) RSSpot *currentSpot;
@property NSInteger map_num;

@end


@protocol ListViewControllerDelegate <NSObject>

- (void)ListViewControllerDidCancelEditing:(id)sender;
- (void)ListViewController:(id)sender didSelectSpot:(RSSpot*)spot;

@end
