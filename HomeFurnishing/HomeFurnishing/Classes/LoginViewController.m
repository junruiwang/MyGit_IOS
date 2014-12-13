//
//  LoginViewController.m
//  HomeFurnishing
//
//  Created by jrwang on 14-12-11.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import "LoginViewController.h"
#import "SceneModeViewController.h"
#import "SettingIndexViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelLoginClicked:(id)sender
{
    [self resignKeyboard];
    [self backToRootController];
}

-(IBAction)checkButtonClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
}

-(IBAction)loginButtonClicked:(id)sender
{
    [self resignKeyboard];
    
//    if (!self.settingViewController) {
//        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        self.settingViewController = [board instantiateViewControllerWithIdentifier:@"SettingIndexViewController"];
//        self.settingViewController.delegate = self;
//    }
//    [UIView transitionFromView:self.view toView:self.settingViewController.view duration:0.5 options:UIViewAnimationOptionTransitionCurlUp completion:NULL];
    
    [self performSegueWithIdentifier:@"fromLoginToSetting" sender:nil];
}

-(IBAction)dismissCurrentKeyboard:(id)sender
{
    [self resignKeyboard];
}

-(void)resignKeyboard
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
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
