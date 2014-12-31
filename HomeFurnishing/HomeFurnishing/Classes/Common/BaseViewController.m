//
//  BaseViewController.m
//  HomeFurnishing
//
//  Created by jrwang on 14-12-11.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

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
    if (self.customIndicator == nil)
    {
        self.customIndicator = [[HZActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 150, 0, 0)];
        self.customIndicator.backgroundColor = self.view.backgroundColor;
        self.customIndicator.opaque = YES;
        self.customIndicator.steps = 16;
        self.customIndicator.finSize = CGSizeMake(8, 40);
        self.customIndicator.indicatorRadius = 20;
        self.customIndicator.stepDuration = 0.100;
        self.customIndicator.color = [UIColor colorWithRed:0.0 green:34.0/255.0 blue:85.0/255.0 alpha:1.000];
        self.customIndicator.roundedCoreners = UIRectCornerTopRight;
        self.customIndicator.cornerRadii = CGSizeMake(10, 10);
        [self.customIndicator startAnimating];
        
        [self.view bringSubviewToFront:self.customIndicator];
        [self.view addSubview:self.customIndicator];
    }
}

- (void)hideLoadingView
{
    [self.customIndicator removeFromSuperview];
    self.customIndicator = nil;
}

@end
