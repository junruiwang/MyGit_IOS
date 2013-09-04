//
//  RegistViewController.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-18.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//




#import "RegistViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JJUnderlineButton.h"
#import "ParameterManager.h"
#import "NSDataAES.h"
#import "ValidateInputUtil.h"

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UIView *formView;

- (void)showRegisterRegulations;
- (void)hideRegisterRegulations;

- (void)userRegistAction;

- (void)userLoginAction;
- (void)loginSuccessProcess;

@end

@implementation RegistViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.formView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.formView.layer.borderWidth = 1.0;
    
    JJUnderlineButton *regulationsBtn = [JJUnderlineButton buttonWithType:UIButtonTypeCustom];
    regulationsBtn.frame = CGRectMake(152, 190, 150, 15);
    [regulationsBtn setTitle:@"锦江礼享⁺注册细则" forState:UIControlStateNormal];
    [regulationsBtn setTitleColor:[UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:202.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [regulationsBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [regulationsBtn addTarget:self action:@selector(showRegisterRegulations) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regulationsBtn];
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(164,205,127,1)];
    lineView.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:202.0/255.0 alpha:1.0];
    [self.view addSubview:lineView];
    [self addRegulaModeView];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"快速会员注册页面";
    [super viewWillAppear:animated];
}

- (void)addRegulaModeView
{    
    self.modeView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.modeView.backgroundColor = [UIColor blackColor];
    self.modeView.alpha = 0.5;
    [self.navigationController.view.window addSubview:self.modeView];

    self.regulaView = [[UIView alloc] initWithFrame:CGRectMake(20, 600, 280, 370)];
    self.regulaView.backgroundColor = [UIColor clearColor];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(245, 0, 35, 35);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"button-close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(hideRegisterRegulations) forControlEvents:UIControlEventTouchUpInside];

    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 25, 280, 335)];
    self.textView.editable = NO;

    CALayer *subLayer = [CALayer layer];
    subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    subLayer.shadowOffset = CGSizeMake(0, 1);
    subLayer.shadowRadius = 5.0;
    subLayer.shadowColor = [UIColor blackColor].CGColor;
    subLayer.shadowOpacity = 0.8;
    subLayer.frame = CGRectMake(0, 0, 280, 370);
    subLayer.cornerRadius = 10;
    subLayer.borderWidth = 0;
    [self.regulaView.layer addSublayer:subLayer];
    [self.regulaView addSubview:self.textView];
    [self.regulaView addSubview:closeBtn];

    [self.navigationController.view.window addSubview:self.regulaView];
    [self.modeView setHidden:YES];
}


- (IBAction) registButtonClick
{
    if ([self verifyRegist])
    {
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"快速会员注册页面"
                                                        withAction:@"快速会员注册"
                                                         withLabel:@"快速会员注册按钮"
                                                         withValue:nil];
        [UMAnalyticManager eventCount:@"快速会员注册" label:@"快速会员注册按钮"];
        
        self.userName = [self.userNameField text];
        self.password = [self.passwordField.text MD5String];
        [self userRegistAction];
    }
}

- (void)userRegistAction
{
    if (!self.registParser)
    {
        self.registParser = [[RegistParser alloc] init];
        self.registParser.serverAddress = kUserRegisterURL;
    }
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"mobile" WithValue:self.userName];
    [parameterManager parserStringWithKey:@"pswd" WithValue:[self.password stringByURLEncodingStringParameter]];
    [parameterManager parserStringWithKey:@"source" WithValue:@"Mobile"];
    [self.registParser setRequestString:[parameterManager serialization]];
    [self.registParser setDelegate:self];
    [self.registParser start];
    [self showIndicatorView];
}


- (void)registSuccessProcess
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"快速会员注册页面"
                                                    withAction:@"快速会员注册成功跳转登录"
                                                     withLabel:@"快速会员注册成功跳转登录"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"快速会员注册成功跳转登录" label:@"快速会员注册成功跳转登录按钮"];
    //注册成功调用登录接口
    [self userLoginAction];
}

- (void)userLoginAction
{
    if (!self.loginParser)
    {
        self.loginParser = [[LoginParser alloc] init];
        self.loginParser.serverAddress = kUserLoginURL;
    }
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"loginName" WithValue:self.userName];
    [parameterManager parserStringWithKey:@"pswd" WithValue:self.password];
    [self.loginParser setRequestString:[parameterManager serialization]];
    [self.loginParser setDelegate:self];
    [self.loginParser start];
}

- (void)loginSuccessProcess
{
    self.userInfo.loginName = self.userName;
    self.userInfo.flag = @"true";
    TheAppDelegate.userInfo = self.userInfo;
    [self hideIndicatorView];
    [self performSegueWithIdentifier:@"registToMember" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resignEditing:(id)sender
{
    if ([sender isKindOfClass:[UITextField class]])
    {
        [sender resignFirstResponder];
    }
    else
    {
        [self.userNameField resignFirstResponder];
        [self.passwordField resignFirstResponder];
        [self.confirmField resignFirstResponder];
    }
}

- (void)showRegisterRegulations
{
    [self resignEditing:nil];
    self.modeView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.modeView.hidden = NO;
        self.textView.text = JJ_MEMBER_PROTOCOL;
        self.regulaView.frame = CGRectMake(20, 80, 280, 370);
    }completion:NULL];
}

- (void)hideRegisterRegulations
{
    [UIView animateWithDuration:0.3 animations:^{
        self.regulaView.frame = CGRectMake(20, 600, 280, 370);
    }completion:^(BOOL finished) {
        self.modeView.hidden = YES;
    }];
}

- (BOOL)verifyRegist
{
    //手机号校验
    if (![ValidateInputUtil isNotEmpty:self.userNameField.text fieldCName:@"手机号"])  {   return NO;  }
    if (![ValidateInputUtil isEffectivePhone:self.userNameField.text])  {   return NO;  }
    //密码校验
    if (![ValidateInputUtil isNotEmpty:self.passwordField.text fieldCName:@"密码"])   {   return NO;  }
    if (![ValidateInputUtil isEffectivePassword:self.passwordField.text])   {   return NO;  }
    //确认密码校验
    if (![ValidateInputUtil isNotEmpty:self.confirmField.text fieldCName:@"确认密码"])  {   return NO;  }
    if ([self.passwordField.text caseInsensitiveCompare:self.confirmField.text] != NSOrderedSame)
    {   [self showAlertMessage: NSLocalizedString(@"两次输入的密码不一致", nil)]; return NO;  }

    return YES;
}

#pragma mark - GDataXMLParserDelegate
- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[RegistParser class]])
    {
        [self registSuccessProcess];
    }
    else if ([parser isKindOfClass:[LoginParser class]])
    {
        self.userInfo = data[@"userInfo"];
        [self loginSuccessProcess];
    }
}



- (void)viewDidUnload {
    [self setFormView:nil];
    [super viewDidUnload];
}
@end
