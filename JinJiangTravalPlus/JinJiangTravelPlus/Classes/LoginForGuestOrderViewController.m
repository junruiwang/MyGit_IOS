//
//  LoginForOrderViewController.m
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 13-4-26.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "LoginForGuestOrderViewController.h"

#import "ParameterManager.h"
#import "NSDataAES.h"

@interface LoginForGuestOrderViewController ()
@property (weak, nonatomic) UITextField *textField;

@end

@implementation LoginForGuestOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction) login : (id)sender
{
    [self.userName respondsToSelector:YES];
    [self.passWord respondsToSelector:YES];
    if (!self.loginParser)
    {
        self.loginParser = [[LoginParser alloc] init];
        [self.loginParser setServerAddress:kUserLoginURL];
    }
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"loginName" WithValue:self.userName.text];
    [parameterManager parserStringWithKey:@"pswd" WithValue:[self.passWord.text MD5String]];
    [self.loginParser setServerAddress:kUserLoginURL];
    [self.loginParser setRequestString:[parameterManager serialization]];
    [self.loginParser setDelegate:self];
    [self.loginParser start];
}

#pragma mark - GDataXMLParserDelegate
- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[LoginParser class]])
    {
//        [self hideIndicatorView];
        [self setUserInfo:data[@"userInfo"]];

        [self.delegate guestLoginAfterProcess:self.userInfo];
    }
}

- (void)parser:(GDataXMLParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    if ([parser isKindOfClass:[LoginParser class]])
    {
        [self showAlertMessageWithOkButton:msg title:nil tag:0 delegate:nil];
        self.passWord.text = @"";
    }
}

- (IBAction)onTapScreen:(UITapGestureRecognizer *)sender {
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
}

- (IBAction)closeLoginView:(id)sender {
    [self.delegate guestLoginClose];
}

- (IBAction)onEditExit:(UITextField *)sender {
    [((UITextField *)sender) resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
