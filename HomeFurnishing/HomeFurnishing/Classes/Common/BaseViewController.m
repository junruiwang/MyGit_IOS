//
//  BaseViewController.m
//  HomeFurnishing
//
//  Created by jrwang on 14-12-11.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webview loading

- (void)showLoadingView
{
    if (self.customIndicator == nil)
    {
        self.customIndicator = [[HZActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 150, 0, 0)];
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

#pragma mark auto Rotation
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
