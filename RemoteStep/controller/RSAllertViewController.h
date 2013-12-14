//
//  RSAllertViewController.h
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/12/14.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <UIKit/UIKit.h>
enum RSAllertMode {ALLERT_MODE_1, ALLERT_MODE_2 };
typedef void (^RSAllertCompletionAction)(NSString *locationName);
typedef void (^RSAllertCancelAction)();



@interface RSAllertViewController : UIViewController

@property enum RSAllertMode allertMode;
@property (nonatomic,copy) RSAllertCancelAction cancelAction;
@property (nonatomic,copy) RSAllertCompletionAction completionAction;


- (void)willRemoveFromParentViewController:(UIViewController*)parent;


@end
