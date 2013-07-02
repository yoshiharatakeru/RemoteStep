//
//  ListViewController.h
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/07/02.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

@protocol ListViewControllerDelegate;

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,weak) id delegate;

@end


@protocol ListViewControllerDelegate <NSObject>

- (void)ListViewControllerDidCancelEditing:(id)sender;

@end
