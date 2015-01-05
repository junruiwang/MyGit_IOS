//
//  BaseViewController.m
//  HomeFurnishing
//
//  Created by jrwang on 14-12-11.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()<MBProgressHUDDelegate> {
    MBProgressHUD *progressHUD;
}

- (void)resizePageView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.backgroundColor = [UIColor clearColor];
    [self.bgImageView sizeToFit];
    [self.bgImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.bgImageView];
    [self.view sendSubviewToBack:self.bgImageView];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.bgImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:00.0f];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.bgImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:00.0f];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.bgImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:00.0f];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.bgImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:00.0f];
    [self.view addConstraint:constraint];
    **/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self resizePageView];
}

- (void)resizePageView
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    self.view.frame = screenSize;
    /*
    //Screen width
    CGFloat swidth = screenSize.size.width;
    //Screen height
    CGFloat sheight = screenSize.size.height;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            self.view.frame = CGRectMake(0, 0, swidth < sheight ? swidth : sheight, swidth < sheight ? sheight : swidth);
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            self.view.frame = CGRectMake(0, 0, swidth < sheight ? swidth : sheight, swidth < sheight ? sheight : swidth);
            break;
        case UIDeviceOrientationLandscapeLeft:
            self.view.frame = CGRectMake(0, 0, swidth > sheight ? swidth : sheight, swidth > sheight ? sheight : swidth);
            break;
        case UIDeviceOrientationLandscapeRight:
            self.view.frame = CGRectMake(0, 0, swidth > sheight ? swidth : sheight, swidth > sheight ? sheight : swidth);
            break;
        default:
            break;
    }
    **/
}


- (void)backToRootController
{
    [UIView
     transitionWithView:self.navigationController.view
     duration:0.5
     options:UIViewAnimationOptionTransitionCurlDown
     animations:^{
         [self.navigationController popToRootViewControllerAnimated:NO];
     } completion:NULL];
}

- (void)backTotargetController:(UIViewController *)viewController
{
    [UIView
     transitionWithView:self.navigationController.view
     duration:0.5
     options:UIViewAnimationOptionTransitionCurlDown
     animations:^{
         [self.navigationController popToViewController:viewController animated:NO];
     } completion:NULL];
}


#pragma mark - webview loading

- (void)showLoadingView
{
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progressHUD];
    progressHUD.delegate = self;
//    progressHUD.labelText = @"Loading";
    [progressHUD show:YES];
}

- (void)hideLoadingView
{
    [progressHUD hide:YES];
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [progressHUD removeFromSuperview];
    progressHUD = nil;
}

@end
