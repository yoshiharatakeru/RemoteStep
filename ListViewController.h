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

@interface ListViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic,weak) id delegate;
@property (nonatomic,strong) RSSpot *currentSpot;

@end


@protocol ListViewControllerDelegate <NSObject>

- (void)ListViewControllerDidCancelEditing:(id)sender;

@end
