//
//  SettingIndexViewController.m
//  HomeFurnishing
//
//  Created by jrwang on 14-12-13.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import "SettingIndexViewController.h"
#import "SceneModeViewController.h"
#import "LoginViewController.h"

@interface SettingIndexViewController ()

@end

@implementation SettingIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            self.bgImageView.image = [UIImage imageNamed:@"background-Portrait.png"];
            break;
        case UIDeviceOrientationLandscapeLeft:
            self.bgImageView.image = [UIImage imageNamed:@"background-Landscape.png"];
            break;
        case UIDeviceOrientationLandscapeRight:
            self.bgImageView.image = [UIImage imageNamed:@"background-Landscape.png"];
            break;
        default:
            break;
    }
}

-(IBAction)loginoutButtonClicked:(id)sender
{
    BOOL isExist = NO;
    UIViewController *loginViewController = nil;
    NSArray *controllers = [self.navigationController viewControllers];
    for (UIViewController *viewCtrl in controllers) {
        if ([viewCtrl isKindOfClass:[LoginViewController class]]) {
            loginViewController = viewCtrl;
            isExist = YES;
            break;
        }
    }
    if (isExist) {
        [self backTotargetController:loginViewController];
    } else {
        [self performSegueWithIdentifier:@"fromSettingToLogin" sender:nil];
    }
}

-(IBAction)backHome:(id)sender
{
    [self backToRootController];
}

#pragma mark auto Rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    switch (toInterfaceOrientation) {
        case UIDeviceOrientationPortrait:
            self.bgImageView.image = [UIImage imageNamed:@"background-Portrait.png"];
            break;
        case UIDeviceOrientationLandscapeLeft:
            self.bgImageView.image = [UIImage imageNamed:@"background-Landscape.png"];
            break;
        case UIDeviceOrientationLandscapeRight:
            self.bgImageView.image = [UIImage imageNamed:@"background-Landscape.png"];
            break;
        default:
            break;
    }
}

@end
