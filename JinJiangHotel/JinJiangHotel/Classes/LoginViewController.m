//
//  LoginViewController.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-14.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "LoginViewController.h"
#import "HotelBookingViewController.h"
#import "ParameterManager.h"
#import "NSDataAES.h"
#import "Constants.h"
#import "ValidateInputUtil.h"

const unsigned int saveAccountTag = 100;
const unsigned int autoLoginTag = 101;

@interface LoginViewController ()

@property(nonatomic) BOOL saveAccountFlag;
@property(nonatomic) BOOL autoLoginFlag;

- (void)loginSuccessProcess;

@end

@implementation LoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.mainLabel.text = NSLocalizedStringFromTable(@"login", @"Login", @"");

    [self.saveAccountSwitchView transformToLogin];
    self.saveAccountFlag = YES;
    self.saveAccountSwitchView.tag = saveAccountTag;
    [self.saveAccountSwitchView setDelegate:self];
    
    [self.autoLoginSwitchView transformToLogin];
    self.autoLoginFlag = YES;
    self.autoLoginSwitchView.tag = autoLoginTag;
    [self.autoLoginSwitchView setDelegate:self];
    
    //set default account
	NSString *userAccount = [[NSUserDefaults standardUserDefaults] stringForKey:kRestoreSaveAccount];
    if (userAccount != nil && ![userAccount isEqualToString:@""])
    {
        self.userNameField.text = userAccount;
    }

}

- (void)downloadData
{
    if (!self.loginParser)
    {
        self.loginParser = [[LoginParser alloc] init];
        [self.loginParser setServerAddress:kUserLoginURL];
    }
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"loginName" WithValue:self.userName];
    [parameterManager parserStringWithKey:@"pswd" WithValue:self.password];
    [self.loginParser setServerAddress:kUserLoginURL];
    [self.loginParser setRequestString:[parameterManager serialization]];
    [self.loginParser setDelegate:self];
    [self.loginParser start];
    
    [self showIndicatorView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)editingDidNext:(id)sender
{
    if (sender == self.userNameField)
    {
        [self.userNameField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    }
}

- (IBAction)resignEditing:(id)sender
{
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (IBAction) loginButtonClick
{    
    if (![ValidateInputUtil isNotEmpty:self.userNameField.text fieldCName:@"用户名"])
    {   return; }
    if (![ValidateInputUtil isNotEmpty:self.passwordField.text fieldCName:@"密码"])
    {   return; }
    [self setUserName:self.userNameField.text];
    [self setPassword:[self.passwordField.text MD5String]];

    // save user account to disk
    if (self.saveAccountFlag)
    {   [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:kRestoreSaveAccount]; }
    else
    {   [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRestoreSaveAccount];             }
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self downloadData];
}


- (void)loginSuccessProcess
{
    [self.userInfo setLoginName:self.userName];
    [self.userInfo setFlag:@"true"];
    [TheAppDelegate setUserInfo:self.userInfo];
    // save userinfo to disk
    if (self.autoLoginFlag)
    {   [[NSUserDefaults standardUserDefaults] setObject:[self.userInfo archived] forKey:kRestoreAutoLogin];    }
    else
    {   [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRestoreAutoLogin];                           }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//
//    //resave deviceToken after login
//    if (TheAppDelegate.pushManager != nil) {
//        [TheAppDelegate.pushManager saveRemoteDeviceTokenAfterLogin];
//    }
    
    switch (TheAppDelegate.loginEnterance)
    {
        case JJHDefaultLogin:
        {
            NSString *msg = [NSString stringWithFormat:@"会员ID:%@，登录名:%@", self.userInfo.uid, self.userInfo.loginName];
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"登录成功"
                                      message:msg
                                      delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                      otherButtonTitles:nil];
            [alertView show];

            break;
        }
        case JJHHotelDetailLogin:
        {
            [self performSegueWithIdentifier:FROM_LOGIN_TO_BOOKING sender:self];
            break;
        }
        default:
        {
//            [self performSegueWithIdentifier:@"loginToMember" sender:nil];
            break;
        }
    }

    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:FROM_LOGIN_TO_BOOKING]) {
        HotelBookingViewController *hbvc = segue.destinationViewController;
        hbvc.orderPriceConfirmForm = self.hotelPriceConfirmForm;
    }
}


#pragma mark - GDataXMLParserDelegate

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[LoginParser class]])
    {
        [self hideIndicatorView];
        [self setUserInfo:data[@"userInfo"]];
        [self loginSuccessProcess];
    }
    
}

#pragma mark - LoginSwitchViewDelegate

- (void)switchViewDidEndSetting:(LoginSwitchView *)switchView
{
    if (switchView.tag == saveAccountTag) {
        self.saveAccountFlag = self.saveAccountSwitchView.on;
    } else if (switchView.tag == autoLoginTag) {
        self.autoLoginFlag = self.autoLoginSwitchView.on;
    }
}

@end
