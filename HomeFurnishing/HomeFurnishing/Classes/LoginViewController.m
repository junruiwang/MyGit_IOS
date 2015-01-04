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
#import "Constants.h"
#import "AppDelegate.h"
#import "ValidateInputUtil.h"
#import "LoginParser.h"
#import "CodeUtil.h"
#import "NSDataAES.h"

@interface LoginViewController ()<JsonParserDelegate>

@property(nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property(nonatomic, strong) LoginParser *loginParser;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.serverIdLabel.text = TheAppDelegate.currentServerId;
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.center = self.view.center;
    self.indicatorView.hidden = YES;
    [self.view addSubview:self.indicatorView];
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
    if (TheAppDelegate.currentServerId) {
        if (![ValidateInputUtil isNotEmpty:self.usernameField.text fieldCName:@"请输入账户"]) {
            return;
        }
        if (![ValidateInputUtil isNotEmpty:self.passwordField.text fieldCName:@"请输入密码"]) {
            return;
        }
        [self loginAction];
    } else {
        [ValidateInputUtil showAlertMessage:@"未查找到有效的服务ID，无法登陆！"];
    }
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

- (void)loginAction
{
    NSString *serverId = TheAppDelegate.currentServerId;
    
    if (serverId != nil) {
        if (self.loginParser != nil) {
            [self.loginParser cancel];
            self.loginParser = nil;
        }
        self.loginParser = [[LoginParser alloc] init];
        self.loginParser.serverAddress = kUserLoginURL;
        self.loginParser.requestString = [self md5HexForRequest:serverId];
        self.loginParser.valType = ReturnValueTypeString;
        self.loginParser.delegate = self;
        [self.loginParser start];
        [self.indicatorView startAnimating];
    }
}

- (NSString *)md5HexForRequest:(NSString *)serverId
{
    NSString *token = [[NSUUID UUID] UUIDString];
    NSString *appendStr = [NSString stringWithFormat:@"%@%@", token, kSecretKey];
    NSString *sign = [CodeUtil hexStringFromString:[appendStr MD5String]];
    NSLog(@"sign : %@",sign);
    
    return [NSString stringWithFormat:@"api=true&sign=E50AEBBE04A43A035629B463C138C3C6&token=123&serverId=%@&username=%@&password=%@", serverId, self.usernameField.text, self.passwordField.text];
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

#pragma mark JsonParserDelegate

- (void)parser:(JsonParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    [self.indicatorView stopAnimating];
    NSLog(@"%@",msg);
}

- (void)parser:(JsonParser*)parser DidParsedData:(NSDictionary *)data
{
    [self.indicatorView stopAnimating];
    NSString *flag = [data objectForKey:@"data"];
    if ([flag isEqualToString:@"true"]) {
        [self performSegueWithIdentifier:@"fromLoginToSetting" sender:nil];
    } else {
        [ValidateInputUtil showAlertMessage:@"账户或密码错误，无法登陆！"];
    }
}

@end
