//
//  PasswordManageViewController.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-2-4.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "PasswordManageViewController.h"
#import "ValidateInputUtil.h"
#import "SVProgressHUD.h"
#import "ParameterManager.h"
#import "NSDataAES.h"
#import <QuartzCore/QuartzCore.h>

#define OLD_PASSWORD_TAG 100
#define CURRENT_PASSWORD_TAG 101
#define CONFIRM_PASSWORD_TAG 102

@interface PasswordManageViewController ()

@end

@implementation PasswordManageViewController

@synthesize updatePasswordParser;

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
    self.title = @"修改密码";
    self.oldPasswordField.delegate = self;
    self.oldPasswordField.tag = OLD_PASSWORD_TAG;
    self.currentPasswordField.delegate = self;
    self.currentPasswordField.tag = CURRENT_PASSWORD_TAG;
    self.confPasswordField.delegate = self;
    self.confPasswordField.tag = CONFIRM_PASSWORD_TAG;
	// Do any additional setup after loading the view.
    
    self.formView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.formView.layer.borderWidth = 1.0;
}

-(void)viewWillAppear:(BOOL)animated{
    self.trackedViewName = @"修改密码页面";
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.oldPasswordField resignFirstResponder];
    [self.currentPasswordField resignFirstResponder];
    [self.confPasswordField resignFirstResponder];
}

- (IBAction)changePassword:(id)sender
{
    if ([self verify])
    {
        if (!self.updatePasswordParser)
        {
            self.updatePasswordParser = [[UpdatePasswordParser alloc] init];
            self.updatePasswordParser.serverAddress = kUpdatePasswordURL;
        }
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"修改密码页面"
                                                        withAction:@"修改密码"
                                                         withLabel:@"修改密码按钮"
                                                         withValue:nil];
        [UMAnalyticManager eventCount:@"修改密码" label:@"修改密码按钮"];

        ParameterManager* parameterManager = [[ParameterManager alloc] init];
        [parameterManager parserStringWithKey:@"loginName" WithValue:TheAppDelegate.userInfo.loginName];
        [parameterManager parserStringWithKey:@"oldPassword" WithValue:[self.oldPasswordField.text MD5String]];
        [parameterManager parserStringWithKey:@"newPassword" WithValue:[self.currentPasswordField.text MD5String]];
        [self.updatePasswordParser setRequestString:[parameterManager serialization]];
        [self.updatePasswordParser setDelegate:self];
        [self.updatePasswordParser start];
        [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeBlack];
    }
}

- (BOOL)verify
{    
    //当前密码
    if (![ValidateInputUtil isNotEmpty:self.oldPasswordField.text fieldCName:@"当前密码"])   {   return NO;  }
    //新密码
    if (![ValidateInputUtil isNotEmpty:self.currentPasswordField.text fieldCName:@"新密码"])   {   return NO;  }
    if (![ValidateInputUtil isEffectivePassword:self.currentPasswordField.text])   {   return NO;  }

    //确认密码校验
    if (![ValidateInputUtil isNotEmpty:self.confPasswordField.text fieldCName:@"确认密码"])  {   return NO;  }
    if ([self.currentPasswordField.text caseInsensitiveCompare:self.confPasswordField.text] != NSOrderedSame)
    {   [self showAlertMessage: NSLocalizedString(@"两次输入的新密码不一致", nil)]; return NO;  }
    
    return YES;
}

#pragma mark - GDataXMLParserDelegate

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    [SVProgressHUD dismiss];
    [self showAlertMessageWithOkButton:@"密码修改成功！" title:@"信息提示" tag:0 delegate:self];
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    [SVProgressHUD dismiss];
    [self showAlertMessage:msg];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.delegate changedPasswordAfterHandle];
    [self backHome:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.tag == OLD_PASSWORD_TAG)
    {   [self.currentPasswordField becomeFirstResponder];   }
    else if (textField.tag == CURRENT_PASSWORD_TAG)
    {   [self.confPasswordField becomeFirstResponder];      }

    return YES;
}

- (void)viewDidUnload {
    [self setFormView:nil];
    [super viewDidUnload];
}
@end
