//
//  BaseViewController.h
//  HomeFurnishing
//
//  Created by jrwang on 14-12-11.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZActivityIndicatorView.h"

@interface BaseViewController : UIViewController

- (void)backToRootController;
- (void)backTotargetController:(UIViewController *)viewController;

- (void)showLoadingView;
- (void)hideLoadingView;


@end
