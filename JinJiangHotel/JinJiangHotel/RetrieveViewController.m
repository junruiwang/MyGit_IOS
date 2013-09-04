//
//  RetrieveViewController.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-16.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "RetrieveViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ValidateInputUtil.h"
#import "ParameterManager.h"



@interface RetrieveViewController ()

@property (nonatomic, strong) NSString *phoneNumber;

@end

@implementation RetrieveViewController

- (void)initTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkRetrieveTimer) userInfo:self repeats:YES];
    [self.timer fire];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.phoneNumberField becomeFirstResponder];
    
    self.navigationBar.mainLabel.text = NSLocalizedStringFromTable(@"retrieve", @"Retrieve", @"");
    
    self.retrieceButton.titleLabel.text = NSLocalizedStringFromTable(@"getpw", @"Retrieve", @"");
    
    if (TheAppDelegate.sendShotMsgTime >0 && TheAppDelegate.sendShotMsgTime <= 60) {
        [self initTimer];
    }
    CGRect buttonFrame = self.retrieceButton.frame;
    buttonFrame.size.width = 270;
    self.retrieceButton.titleLabel.frame = buttonFrame;
    [self checkRetrieveTimer];
}

- (IBAction)retrievePressed:(UIButton *)sender {
    if ([self verify])
    {
        if (!self.retrieveParser)
        {
            self.retrieveParser = [[RetrieveParser alloc] init];
            self.retrieveParser.serverAddress = kRetrieveURL;
        }
        
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        ParameterManager *parameterManager = [[ParameterManager alloc] init];
        [parameterManager parserStringWithKey:@"telephone" WithValue:[self.phoneNumberField.text stringByTrimmingCharactersInSet:whitespace]];
        [self.retrieveParser setRequestString:[parameterManager serialization]];
        [self.retrieveParser setDelegate:self];
        [self.retrieveParser start];
        [self showIndicatorView];
    }
}

- (BOOL) verify
{
    if (![ValidateInputUtil isNotEmpty:self.phoneNumberField.text fieldCName:@"手机号"])  { return NO; }
    
    if (![ValidateInputUtil isEffectivePhone:self.phoneNumberField.text])  {   return NO;  }
    
    return YES;
}

- (void)checkRetrieveTimer
{
    if (TheAppDelegate.sendShotMsgTime >0 && TheAppDelegate.sendShotMsgTime <= 60) {
        self.retrieceButton.enabled = NO;
        NSString *show = [NSString stringWithFormat:NSLocalizedStringFromTable(@"retrieve count down", @"Retrieve", @""), TheAppDelegate.sendShotMsgTime];
        [self.retrieceButton.titleLabel setText:show];
    } else {
        [self.timer invalidate];
        self.retrieceButton.enabled = YES;
        self.retrieceButton.titleLabel.text = NSLocalizedStringFromTable(@"getpw", @"Retrieve", @"");
    }
}

#pragma mark - GDataXMLParserDelegate
- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[RetrieveParser class]])
    {
        NSString *result = [data valueForKey:@"status"];
        NSString *message;
        
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        [result stringByTrimmingCharactersInSet:whitespace];
        if ([result isEqualToString:@"success"])
        {
            message = [NSString stringWithFormat:@"我们已发送动态密码至您的手机%@，请在登录后及时修改您的密码。若您没有收到短信，可在1分钟后重试。",
                       [self.phoneNumberField.text stringByTrimmingCharactersInSet:whitespace]];
            [self showAlertMessageWithOkButton: message title:@"" tag:0 delegate:self];
            [self hideIndicatorView];
            TheAppDelegate.sendShotMsgTime = TIME;
            [self initTimer];
        }
    }
    [self.phoneNumberField becomeFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0 && buttonIndex == 0)
    {
        self.retrieceButton.enabled = NO;
        TheAppDelegate.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:TheAppDelegate selector:@selector(timerFired:) userInfo:self repeats:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPhoneNumberField:nil];
    [self setRetrieceButton:nil];
    [super viewDidUnload];
}
@end
