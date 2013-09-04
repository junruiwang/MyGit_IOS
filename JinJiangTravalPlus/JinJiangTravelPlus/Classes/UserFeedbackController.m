//
//  UserFeedbackController.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 13-1-8.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "UserFeedbackController.h"
#import <QuartzCore/QuartzCore.h>

const unsigned int alertOK_STATUS_TAG = 960;

@interface UserFeedbackController ()

- (BOOL)verify;
- (void)parentViewPositionReset;
- (void)handleRsigned;
- (void)submit:(id)sender;

@end

@implementation UserFeedbackController

@synthesize userFeedbackParser;


-(void)viewWillAppear:(BOOL)animated{
    [self setTrackedViewName:@"用户意见反馈页面"];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.view removeGestureRecognizer:tapHide];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"意见反馈"];
	// Do any additional setup after loading the view.

    const float version = [[[UIDevice currentDevice] systemVersion] floatValue];

    if (version >= 5.8)
    {
        tapHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRsigned)];
        [self.view addGestureRecognizer:tapHide];[self.navigationController.view addGestureRecognizer:tapHide];
    }
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 111, 280, 35)];
    placeholderLabel.text = @"请将反馈内容控制在200字以内";
    placeholderLabel.font = [UIFont systemFontOfSize:14];
    placeholderLabel.textColor = [UIColor grayColor];
    placeholderLabel.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:placeholderLabel];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
//        self.bgView.frame = CGRectMake(0, 0, 320, 372+100);
//        self.contentImageView.frame = CGRectMake(0, 130, 320, 181+100);
//        self.dashedImageView.frame = CGRectMake(9, 130, 302, 1);
//        self.feedbackContent.frame = CGRectMake(10, 130, 300, 246);
//        placeholderLabel.frame = CGRectMake(15, 130, 280, 35);
//        self.contactPhone.frame = CGRectMake(75, 25, 209, 30);
//        self.contactEmail.frame = CGRectMake(75, 75, 209, 30);;
    }

    if ([TheAppDelegate.userInfo checkIsLogin] == YES)
    {
        [self.contactEmail setText:TheAppDelegate.userInfo.email];
        [self.contactPhone setText:TheAppDelegate.userInfo.mobile];
    }

}

- (void)addRightBarButton
{
    UIButton* targetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [targetBtn setBackgroundImage:[UIImage imageNamed:@"hotel-topbar-btn.png"] forState:UIControlStateNormal];
    [targetBtn setBackgroundImage:[UIImage imageNamed:@"hotel-topbar-btn_press.png"] forState:UIControlStateHighlighted];
    [targetBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    targetBtn.frame = CGRectMake(0, 0, 42, 29);
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 42, 29)];
    subLabel.backgroundColor = [UIColor clearColor];
    subLabel.text = @"提交";
    subLabel.textColor = [UIColor whiteColor];
    subLabel.textAlignment = NSTextAlignmentCenter;
    subLabel.font = [UIFont boldSystemFontOfSize:14];
    [targetBtn addSubview:subLabel];
    
    UIBarButtonItem *fullBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:targetBtn];
    self.navigationItem.rightBarButtonItem = fullBarButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)parentViewPositionReset
{
    const unsigned int ww = self.view.frame.size.width;
    const unsigned int hh = self.view.frame.size.height;
    [UIView beginAnimations:@"parentViewPositionReset" context:nil];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationDuration:0.1];
    self.view.frame = CGRectMake(0, 0, ww, hh);
    [UIView commitAnimations];
}

- (BOOL)verify
{
    [self parentViewPositionReset];

    [self.feedbackContent resignFirstResponder];
    [self.contactEmail resignFirstResponder];
    [self.contactPhone resignFirstResponder];

    if (self.feedbackContent.text == nil || [self.feedbackContent.text isEqualToString:@""])
    {
        [self showAlertMessage: @"请填写您的反馈意见" dismissAfterDelay:kDismissAlertDelay];
        return NO;
    }
    
    if (self.contactEmail.text != nil && ![self.contactEmail.text isEqualToString:@""])
    {
        if ([self.contactEmail.text isEmail] == NO)
        {
            [self showAlertMessage: @"请您填写正确的邮箱" dismissAfterDelay:kDismissAlertDelay];
            return NO;
        }
    }

    if (self.contactPhone.text != nil && ![self.contactPhone.text isEqualToString:@""])
    {
        if ([self.contactPhone.text isPhoneNumber] == NO)
        {
            [self showAlertMessage: @"请您填写正确的手机号码" dismissAfterDelay:kDismissAlertDelay];
            return NO;
        }
    }

    NSUInteger contentLen = self.feedbackContent.text.length;
    if (contentLen > 200)
    {
        [self showAlertMessage: @"请将反馈内容控制在200字以内" dismissAfterDelay:kDismissAlertDelay];
        return NO;
    }

    return YES;
}

#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    placeholderLabel.text = @"";
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        const unsigned int ww = self.view.frame.size.width;
        const unsigned int hh = self.view.frame.size.height;
        [UIView beginAnimations:@"BookView-Invert" context:nil];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationDuration:0.1];
        self.view.frame = CGRectMake(0, -96, ww, hh);
        [UIView commitAnimations];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self parentViewPositionReset];
    
    if ([textView.text isEqualToString:@""])
    {
        placeholderLabel.text = @"请将反馈内容控制在200字以内";
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)handleRsigned
{
    if ([self.feedbackContent isFirstResponder])
    {   [self.feedbackContent resignFirstResponder];    }
    if ([self.contactPhone isFirstResponder])
    {   [self.contactPhone resignFirstResponder];   }
    if ([self.contactEmail isFirstResponder])
    {   [self.contactEmail resignFirstResponder];   }
    [self parentViewPositionReset];
}

#pragma mark - 业务逻辑

- (void)submit:(id)sender
{
    if (![self verify]) {   return; }
    
    
    if (!self.userFeedbackParser)
    {
        self.userFeedbackParser = [[UserFeedbackParser alloc] init];
        self.userFeedbackParser.delegate = self;
        self.userFeedbackParser.serverAddress = kUserFeedbackURL;
    }

    NSString *content = [NSString stringWithFormat:@"%@||%@", TheAppDelegate.userInfo.cardType, self.feedbackContent.text];
    if (TheAppDelegate.userInfo.cardType == nil || [TheAppDelegate.userInfo.cardType isEqualToString:@""]) {
        content = [NSString stringWithFormat:@"NaN||%@", self.feedbackContent.text];
    }
    NSString *requestString = [NSString stringWithFormat: @"&content=%@",content];
    if (self.contactEmail.text != nil && ![self.contactEmail.text isEqualToString:@""])
    {   requestString = [requestString stringByAppendingFormat:@"&email=%@",self.contactEmail.text];    }
    if (self.contactPhone.text != nil && ![self.contactPhone.text isEqualToString:@""])
    {   requestString = [requestString stringByAppendingFormat:@"&phone=%@",self.contactPhone.text];    }

    requestString = [requestString stringByAppendingString:@"&source=Mobile"];
    [self.userFeedbackParser setRequestString:requestString];
    [self.userFeedbackParser start];    [self showIndicatorView];
}

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    [self hideIndicatorView];

    if ([data  objectForKey:@"status"] && [[data objectForKey:@"status"] isEqualToString:@"OK"])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您的反馈已经提交成功，我们非常重视您的每一条意见和建议，这将成为我们持续改善的动力，谢谢您的支持！" delegate:self
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];   [alert setTag:alertOK_STATUS_TAG];  return;
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您的反馈提交失败，请稍后再试！" delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];   [alert setTag:alertOK_STATUS_TAG+2];  return;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == alertOK_STATUS_TAG)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
