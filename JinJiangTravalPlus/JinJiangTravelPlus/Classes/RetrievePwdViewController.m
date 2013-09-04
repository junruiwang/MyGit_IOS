//
//  RetrievePwdViewController.m
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 13-1-31.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "RetrievePwdViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ValidateInputUtil.h"
#import "ParameterManager.h"

#define TIME 60

@interface RetrievePwdViewController ()

@property (nonatomic) int time;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation RetrievePwdViewController

- (void)initSendButton
{
    if (TheAppDelegate.sendShotMsgTime > 0 && TheAppDelegate.sendShotMsgTime < 60) {
        self.sendButton.enabled = NO;
    }
    else
    {
        self.telePhoneTextLabel.text = @"发送动态密码";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.telePhoneTextFeild becomeFirstResponder];
    [self setTitle:@"获取密码"];
    
    
    self.mainView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.mainView.layer.borderWidth = 1.0;

    [self initSendButton];
}

- (void) viewDidDisappear:(BOOL)animated
{
    self.telePhoneTextLabel.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)retrieve:(id)sender
{
    if ([self verify])
    {
        if (!self.retrieveParser)
        {
            self.retrieveParser = [[RetrieveParser alloc] init];
            self.retrieveParser.serverAddress = kRetrieveURL;
        }

        ParameterManager *parameterManager = [[ParameterManager alloc] init];
        [parameterManager parserStringWithKey:@"telephone" WithValue:[self.telePhoneTextFeild.text trim]];
        [self.retrieveParser setRequestString:[parameterManager serialization]];
        [self.retrieveParser setDelegate:self];
        [self.retrieveParser start];
        [self showIndicatorView];
    }
}

- (BOOL) verify
{
    if (![ValidateInputUtil isNotEmpty:self.telePhoneTextFeild.text fieldCName:@"手机号"])  { return NO; }

    if (![ValidateInputUtil isEffectivePhone:self.telePhoneTextFeild.text])  {   return NO;  }

    return YES;
}

- (void)timerFired:(NSTimer *)timer//这个函数将会执行一个循环的逻辑
{
//    NSLog(@"time is %d", TheAppDelegate.sendShotMsgTime);
    if (TheAppDelegate.sendShotMsgTime == 0 )
    {
        [TheAppDelegate.timer invalidate];
        TheAppDelegate.sendShotMsgTime = TIME;
        self.sendButton.enabled = YES;
        self.telePhoneTextLabel.text = @"发送动态密码";
        return;
    }

    TheAppDelegate.sendShotMsgTime --;

    if ( TheAppDelegate.sendShotMsgTime > 0 )
    {
        NSString *show = [NSString stringWithFormat:@"%d秒后重新发送", TheAppDelegate.sendShotMsgTime];
        [self.telePhoneTextLabel setText:show];
    }
}

#pragma mark - GDataXMLParserDelegate
- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[RetrieveParser class]])
    {
        NSString *result = [data valueForKey:@"status"];
        NSString *message;
        [result trim];
        if ([result isEqualToString:@"success"])
        {
            message = [NSString stringWithFormat:@"我们已发送动态密码至您的手机%@，请在登录后及时修改您的密码。若您没有收到短信，可在1分钟后重试。",
                       [self.telePhoneTextFeild.text trim]];
            [self showAlertMessageWithOkButton: message title:@"" tag:0 delegate:self];
            [self hideIndicatorView];
        }
    }
    [self.telePhoneTextFeild becomeFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0 && buttonIndex == 0)
    {
        self.sendButton.enabled = NO;
        TheAppDelegate.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:TheAppDelegate selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [TheAppDelegate.timer fire];
    }
}

- (void)parser:(GDataXMLParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    if (code == 10000)
    {
        [self showAlertMessageWithOkButton: @"您输入的手机号尚未注册或账号存在异常情况，请致电1010-1666进行咨询。" title:@"" tag:-1 delegate:self];
        [self hideIndicatorView];
    }
}

- (void)viewDidUnload {
    [self setMainView:nil];
    [super viewDidUnload];
}
@end
