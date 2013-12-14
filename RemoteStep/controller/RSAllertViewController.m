//
//  RSAllertViewController.m
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/12/14.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "RSAllertViewController.h"

@interface RSAllertViewController ()
{
    //outlet
    __weak IBOutlet UILabel *_lb_title;
    __weak IBOutlet UITextField *_tf_locationName;
    __weak IBOutlet UIButton *_bt_cancel;
    __weak IBOutlet UIButton *_bt_Ok;
    __weak IBOutlet UIView *_baseView;
}

@end

@implementation RSAllertViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //title
    if (_allertMode == ALLERT_MODE_1) {//map1
        _lb_title.text = @"MAP-1の現在地を登録";
   
    }else{//map2
        _lb_title.text = @"MAP-2の現在地を登録";
    }
    
    //button
    [_bt_cancel addTarget:self action:@selector(btCancelPressed) forControlEvents:UIControlEventTouchUpInside];
    [_bt_Ok addTarget:self action:@selector(btOkPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //view design
    _baseView.layer.cornerRadius = 8.0f;
    _baseView.clipsToBounds = YES;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [_tf_locationName becomeFirstResponder];
    
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    self.view.alpha = 0;
    _baseView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    
    [parent.view addSubview:self.view];

    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.alpha = 1;
        _baseView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    
}


- (void)willRemoveFromParentViewController:(UIViewController*)parent
{
    //オリジナル
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark butto action

- (void)btCancelPressed
{
    if (_cancelAction) {
        _cancelAction();
    }
}


- (void)btOkPressed
{
    if (_completionAction) {
        _completionAction(_tf_locationName.text);
    }
}

@end
