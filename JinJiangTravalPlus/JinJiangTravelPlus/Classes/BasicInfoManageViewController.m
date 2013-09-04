//
//  BasicInfoManageViewController.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-1-24.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "BasicInfoManageViewController.h"
#import "Constants.h"
#import "ValidateInputUtil.h"
#import "SVProgressHUD.h"
#import "UpdateBasicInfoParser.h"
#import "ParameterManager.h"
#import <QuartzCore/QuartzCore.h>

@interface BasicInfoManageViewController ()

@property (nonatomic, strong) UpdateBasicInfoParser *updateBasicInfoParser;

@end

@implementation BasicInfoManageViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"编辑个人资料";
    self.phoneField.text = TheAppDelegate.userInfo.mobile;
    self.phoneField.delegate = self;
    self.emailField.text = TheAppDelegate.userInfo.email;
    self.emailField.delegate = self;
    
    
    self.mainView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.mainView.layer.borderWidth = 1.0;
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"修改个人信息页面";
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.phoneField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.doneInKeyboardButton setHidden:YES];
}

#pragma mark 键盘

- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    if (self.doneInKeyboardButton.superview)
    {   [self.doneInKeyboardButton removeFromSuperview];    }
}

- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    if (self.doneInKeyboardButton == nil)
    {
        self.doneInKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5] == YES)
        {   self.doneInKeyboardButton.frame = CGRectMake(0, 568 - 53, 106, 53); }
        else
        {  self.doneInKeyboardButton.frame = CGRectMake(0, 480 - 53, 106, 53);  }

        [self.doneInKeyboardButton setAdjustsImageWhenHighlighted:NO];
        [self.doneInKeyboardButton setImage:[UIImage imageNamed:@"key_done_up@2x.png"] forState:UIControlStateNormal];
        [self.doneInKeyboardButton setImage:[UIImage imageNamed:@"key_done_down@2x.png"] forState:UIControlStateHighlighted];
        [self.doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    if (self.doneInKeyboardButton.superview == nil)
    {   [tempWindow addSubview:self.doneInKeyboardButton];  }
    self.doneInKeyboardButton.hidden=NO;
}

-(void)finishAction
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)updateBasicInfo:(id)sender
{
    if ([self verify])
    {
        if (!self.updateBasicInfoParser)
        {
            self.updateBasicInfoParser = [[UpdateBasicInfoParser alloc] init];
            self.updateBasicInfoParser.serverAddress = kMemberModifyURL;
        }
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"修改个人信息页面"
                                                        withAction:@"修改个人信息"
                                                         withLabel:@"修改个人信息按钮"
                                                         withValue:nil];
        [UMAnalyticManager eventCount:@"修改个人信息" label:@"修改个人信息按钮"];
        
        ParameterManager* parameterManager = [[ParameterManager alloc] init];
        [parameterManager parserStringWithKey:@"phone" WithValue:self.phoneField.text];
        [parameterManager parserStringWithKey:@"email" WithValue:self.emailField.text];
        [self.updateBasicInfoParser setRequestString:[parameterManager serialization]];
        [self.updateBasicInfoParser setDelegate:self];
        [self.updateBasicInfoParser start];
        [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeBlack];
    }
}

- (BOOL)verify
{
    if (![ValidateInputUtil isNotEmpty:self.phoneField.text fieldCName:@"手机号"])
    {   return NO;  }
    if (![ValidateInputUtil isEffectivePhone:self.phoneField.text])
    {   return NO;  }

    if (self.emailField.text != nil && ![self.emailField.text isEqualToString:@""])
    {
        if (![ValidateInputUtil isEffectiveEmail:self.emailField.text])
        {   return NO;  }
    }
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.phoneField == textField)
    {   [self performSelector:@selector(handleKeyboardDidShow:) withObject:nil afterDelay:0.2]; }

    if (self.emailField == textField)
    {   [self.doneInKeyboardButton setHidden:YES];  }

    return YES;
}

#pragma mark - GDataXMLParserDelegate

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    [SVProgressHUD dismiss];
    [self showAlertMessageWithOkButton:@"更新个人信息成功！" title:@"信息提示" tag:0 delegate:self];
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    [SVProgressHUD dismiss];
    [self showAlertMessage:msg];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.delegate updateSuccessAfterHandle];
    [self backHome:nil];
}

- (void)viewDidUnload {
    [self setMainView:nil];
    [super viewDidUnload];
}
@end
