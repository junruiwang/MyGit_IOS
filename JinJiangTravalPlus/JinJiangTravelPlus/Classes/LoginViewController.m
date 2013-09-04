//
//  LoginViewController.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-14.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "LoginViewController.h"
#import "ParameterManager.h"
#import "MemberRightsParser.h"
#import "NSDataAES.h"
#import "ValidateInputUtil.h"
#import "Constants.h"
#import "BillListController.h"
#import "ActivityDetailWebViewController.h"

@interface LoginViewController ()

- (void)loginSuccessProcess;
- (void)closeModalView;

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

- (void)viewWillAppear:(BOOL)animated
{
     self.trackedViewName = @"登录页面";
    [super viewWillAppear:animated];
    if (self.leftTabButton != nil) {
        [self tabTapped:self.leftTabButton];
    }
    [self loadLeftButton];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"会员登录"];

    //set default account
	NSString *userAccount = [[NSUserDefaults standardUserDefaults] stringForKey:kRestoreSaveAccount];
    if (userAccount != nil && ![userAccount isEqualToString:@""])
    {   self.userNameField.text = userAccount;  }
    NSString* message = @" *若您已经持有锦江之星的\"蓝鲸卡\"、\"锦尚卡\"、\"红枫卡\"、\"家园卡\"，且未在“锦江旅行家”网站激活，那么请您先输入您的个人信息进行激活，激活后将自动为您升级为享会员，原有权益和积分将自动转移到新账户。";
    [self.jjInnLabel setText:message];
    
    self.jjInnLabel.textColor = RGBCOLOR(68.0, 138.0, 202.0);

    self.top_view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_top_bg"]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    

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
    
    MemberRightsParser *mrParser = [[MemberRightsParser alloc] init];
    mrParser.delegate = self;
    mrParser.serverAddress = kMemberCardRightsURL;
    mrParser.requestString = [parameterManager serialization];
    [mrParser start];
    
    [self showIndicatorView];
}

- (void)loadLeftButton
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(loginAfterHandle)])
    {
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"nav-close.png"] forState:UIControlStateNormal];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"nav-close-press.png"] forState:UIControlStateHighlighted];
        [leftBtn addTarget:self action:@selector(closeModalView) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)checkboxViewTapped:(id)sender
{
    if (sender == self.saveAccountView)
    {   self.saveAccountBtn.selected = !self.saveAccountBtn.selected;   }
    else if (sender == self.autoLoginView)
    {   self.autoLoginBtn.selected = !self.autoLoginBtn.selected;       }
}

- (IBAction)checkboxClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

- (IBAction)tabTapped:(id)sender
{
    [self resignEditing];
    if (sender == self.leftTabButton)
    {
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"登录页面"
                                                        withAction:@"登录页面点击锦江旅行家"
                                                         withLabel:@"登录页面点击锦江旅行家页签"
                                                         withValue:nil];
        [UMAnalyticManager eventCount:@"登录页面点击锦江旅行家" label:@"登录页面点击锦江旅行家页签"];

        [self.leftTabButton setImage:[UIImage imageNamed:@"login_top_but_jjt_press.png"] forState:UIControlStateNormal];
        [self.leftTabButton setImage:[UIImage imageNamed:@"login_top_but_jjt_press.png"] forState:UIControlStateHighlighted];
        [self.rightTabButton setImage:[UIImage imageNamed:@"login_top_but_jjzx.png"] forState:UIControlStateNormal];
        [self.rightTabButton setImage:[UIImage imageNamed:@"login_top_but_jjzx.png"] forState:UIControlStateHighlighted];        

        [self.bgImageView setImage:[UIImage imageNamed:@"text-bg-left.png"]];
        [self.leftTabView setHidden:NO];   [self.rightTabView setHidden:YES];
    }
    else
    {
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"登录页面"
                                                        withAction:@"登录页面点击锦江之星"
                                                         withLabel:@"登录页面点击锦江之星页签"
                                                         withValue:nil];
        [UMAnalyticManager eventCount:@"登录页面点击锦江之星" label:@"登录页面点击锦江之星页签"];

        [self.leftTabButton setImage:[UIImage imageNamed:@"login_top_but_jjt.png"] forState:UIControlStateNormal];
        [self.leftTabButton setImage:[UIImage imageNamed:@"login_top_but_jjt.png"] forState:UIControlStateHighlighted];
        [self.rightTabButton setImage:[UIImage imageNamed:@"login_top_but_jjzx_press.png"] forState:UIControlStateNormal];
        [self.rightTabButton setImage:[UIImage imageNamed:@"login_top_but_jjzx_press.png"] forState:UIControlStateHighlighted];

        [self.bgImageView setImage:[UIImage imageNamed:@"text-bg-right.png"]];
        [self.leftTabView setHidden:YES];  [self.rightTabView setHidden:NO];
    }
}

- (IBAction)editingDidNext:(id)sender
{
    if (sender == self.userNameField)
    {
        [self.userNameField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    }
}

- (IBAction)resignEditing
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
    if (self.saveAccountBtn.selected == YES)
    {   [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:kRestoreSaveAccount]; }
    else
    {   [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRestoreSaveAccount];             }
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self downloadData];
}

- (IBAction)activationBtnClicked:(id)sender
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"登录页面"
                                                    withAction:@"登录页面会员自助激活"
                                                     withLabel:@"登录页面会员自助激活按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"登录页面会员自助激活" label:@"登录页面会员自助激活按钮"];
}

- (void)loginSuccessProcess
{
    [self.userInfo setLoginName:self.userName];
    [self.userInfo setFlag:@"true"];
    [TheAppDelegate setUserInfo:self.userInfo];
    // save userinfo to disk
    if (self.autoLoginBtn.selected == YES)
    {   [[NSUserDefaults standardUserDefaults] setObject:[self.userInfo archived] forKey:kRestoreAutoLogin];    }
    else
    {   [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRestoreAutoLogin];                           }
    [[NSUserDefaults standardUserDefaults] synchronize];

    //resave deviceToken after login
    if (TheAppDelegate.pushManager != nil) {
        [TheAppDelegate.pushManager saveRemoteDeviceTokenAfterLogin];
    }
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(loginAfterHandle)])
    {   [self.delegate loginAfterHandle]; [self closeModalView];  }
    else
    {
        switch (TheAppDelegate.customEnumType)
        {
            case JJCustomTypeBill:
            {
                 [self performSegueWithIdentifier:FROM_LOGIN_TO_BILLLIST sender:nil];
                break;
            }
            case JJCustomTypeMember:
            {
                [self performSegueWithIdentifier:@"loginToMember" sender:nil];
                break;
            }
            case JJCustomTypeShakeAward:{
                [self performSegueWithIdentifier:FROM_LOGIN_TO_SHAKE sender:nil];
                break;
            }
            case JJCustomTypeActivity:{
                [self performSegueWithIdentifier:@"loginToActivity" sender:self];
                break;
            }
            default:
            {
                [self performSegueWithIdentifier:@"loginToMember" sender:nil];
                break;
            }
        }
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loginToActivity"]) {
        
        ActivityDetailWebViewController* activityDetailWebViewController = segue.destinationViewController;
        activityDetailWebViewController.url = self.activityUrl;
        activityDetailWebViewController.config = self.activeConfig;
    }
}

- (void)closeModalView
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)backHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    else if ([parser isKindOfClass:[MemberRightsParser class]])
    {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"memberCardRight"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
