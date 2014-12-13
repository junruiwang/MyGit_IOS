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

@interface LoginViewController ()<ControllerFunction>

@property(nonatomic, strong) SettingIndexViewController *settingViewController;

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
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(dismissViewController:)]) {
        [self.delegate dismissViewController:kLoginView];
    }
}

-(IBAction)checkButtonClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
}

-(IBAction)loginButtonClicked:(id)sender
{
    [self resignKeyboard];
    
    if (!self.settingViewController) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.settingViewController = [board instantiateViewControllerWithIdentifier:@"SettingIndexViewController"];
        self.settingViewController.delegate = self;
    }
    [UIView transitionFromView:self.view toView:self.settingViewController.view duration:0.5 options:UIViewAnimationOptionTransitionCurlUp completion:NULL];
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

#pragma mark delegate ControllerFunction

- (void)dismissViewController:(HFController) viewController
{
    if (viewController == kSettingIndexView) {
        [UIView transitionFromView:self.settingViewController.view toView:self.view duration:0.5 options:UIViewAnimationOptionTransitionCurlDown completion:NULL];
    }
}

@end
