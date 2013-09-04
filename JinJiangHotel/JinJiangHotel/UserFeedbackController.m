//
//  UserFeedbackController.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 13-1-8.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "UserFeedbackController.h"
#import "ValidateInputUtil.h"
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
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [super viewWillDisappear:animated];
//    [self.navigationController.view removeGestureRecognizer:tapHide];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bodyView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"body_bg.png"]];

    self.tilingView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tiling_bg.png"]];

    self.bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom_bg.png"]];

    self.contactView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"twoLine_textfield_bg.png"]];

    self.feedbackContent.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"feedback_memo_bg.png"]];

    self.placeholderLabel.textColor = RGBCOLOR(160.0, 160.0, 160.0);

    self.contactPhone.textColor = RGBCOLOR(160.0, 160.0, 160.0);

    self.contactEmail.textColor = RGBCOLOR(160.0, 160.0, 160.0);

    UITapGestureRecognizer *resetViewFrame =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resetViewFrame)];

    [self.containerBgView addGestureRecognizer:resetViewFrame];

    self.navigationBar.mainLabel.text = NSLocalizedStringFromTable(@"feedback", @"Feedback", @"");

    UIButton *submitBut = [UIButton buttonWithType:UIButtonTypeCustom];
    
    submitBut.frame = CGRectMake(240, 12, 60, 24);

    [submitBut setTitle:NSLocalizedStringFromTable(@"submit", @"Feedback", @"") forState:UIControlStateNormal];

    submitBut.titleLabel.textColor = [UIColor whiteColor];
    submitBut.titleLabel.font = [UIFont boldSystemFontOfSize: 12.0f];
    submitBut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"submit.png"]];

    [submitBut addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];

    [self.navigationBar addSubview:submitBut];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) resetViewFrame
{
    [self parentViewPositionReset];
    [self.contactPhone resignFirstResponder];
    [self.contactEmail resignFirstResponder];
    [self.feedbackContent resignFirstResponder];
}

- (void)parentViewPositionReset
{
    const unsigned int ww = self.containerBgView.frame.size.width;
    const unsigned int hh = self.containerBgView.frame.size.height;
    [UIView beginAnimations:@"parentViewPositionReset" context:nil];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationDuration:0.1];
    self.containerBgView.frame = CGRectMake(0, 50, ww, hh);
    [UIView commitAnimations];
}

- (BOOL)verify
{
    [self parentViewPositionReset];

    [self.feedbackContent resignFirstResponder];
    [self.contactEmail resignFirstResponder];
    [self.contactPhone resignFirstResponder];

    if (![ValidateInputUtil isNotEmpty:self.feedbackContent.text fieldCName:@"反馈意见"])
    {
        return NO;
    }
    
    
    NSCharacterSet *whitespaceForEmail = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    self.contactEmail.text = [self.contactEmail.text stringByTrimmingCharactersInSet:whitespaceForEmail];

    if (self.contactEmail.text != nil && ![self.contactEmail.text isEqualToString:@""])
    {

        if ([ValidateInputUtil isEffectiveEmail:self.contactEmail.text] == NO)
        {
            return NO;
        }
    }

    
    NSCharacterSet *whitespaceForPhone = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    self.contactPhone.text = [self.contactPhone.text stringByTrimmingCharactersInSet:whitespaceForPhone];

    if (self.contactPhone.text != nil && ![self.contactPhone.text isEqualToString:@""])
    {
        if ([ValidateInputUtil isEffectivePhone:self.contactPhone.text] == NO)
        {
            return NO;
        }
    }

    NSCharacterSet *whitespaceForFeedBackContent = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    self.feedbackContent.text = [self.feedbackContent.text stringByTrimmingCharactersInSet:whitespaceForFeedBackContent];
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
    self.placeholderLabel.text = @"";

    if ([[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height < 500)
    {
        const unsigned int ww = self.containerBgView.frame.size.width;
        const unsigned int hh = self.containerBgView.frame.size.height;
        [UIView beginAnimations:@"BookView-Invert" context:nil];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationDuration:0.1];
        self.containerBgView.frame = CGRectMake(0, -96, ww, hh);
        [UIView commitAnimations];
    }

    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self parentViewPositionReset];
    
    if ([textView.text isEqualToString:@""])
    {
        self.placeholderLabel.text = @"请将反馈内容控制在200字以内";
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

- (void) submit : (id) sender
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
