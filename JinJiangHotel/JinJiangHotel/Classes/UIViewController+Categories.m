//
//  UIViewController+Categories.m
//  JinJiangTravalPlus
//
//  Created by Leon on 10/29/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#import "Constants.h"
#import "UIViewController+Categories.h"

@implementation UIViewController (Categories)

- (void)backAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dimissAlert:(UIAlertView *)alertView
{
    if (alertView)
    {
        [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
        //[alertView release];
    }
}

// never show more than one auto dismiss alert at same time, it will cause crash
- (void)showAlertMessage:(NSString *)msg dismissAfterDelay:(NSTimeInterval)delay
{
    UIAlertView *alertView = [[UIAlertView alloc]
                               initWithTitle:nil//NSLocalizedString(@"Notice", nil)
                               message:nil
                               delegate:nil
                               cancelButtonTitle:nil
                               otherButtonTitles:nil];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 260.0f, 40.0f)];
    label.numberOfLines = 2; // if the text too long, the alert view should not be dismissed automatic.
    label.text = msg;
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    // Show alert and wait for it to finish displaying
    [alertView show];
    while (CGRectEqualToRect(alertView.bounds, CGRectZero));

    // Find the center for the text field and add it
    CGRect bounds = alertView.bounds;
    label.center = CGPointMake(bounds.size.width / 2.0f, bounds.size.height / 2.0f - 5.0);
    [alertView addSubview:label];
    [alertView show];
    [self performSelector:@selector(dimissAlert:) withObject:alertView afterDelay:delay];
}

- (void)showAlertMessage:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"信息提示", nil)
                              message:msg
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                              otherButtonTitles:nil];
    [alertView show];
}

- (void)showAlertMessageWithOkCancelButton:(NSString *)msg title:(NSString *)title tag:(NSInteger)tag delegate:(id)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:msg
                              delegate:delegate
                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                              otherButtonTitles:NSLocalizedString(@"Ok", nil), nil];
    alertView.tag = tag;
    [alertView show];
}

- (void)showAlertMessageWithOkButton:(NSString *)msg title:(NSString *)title tag:(NSInteger)tag delegate:(id)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:msg
                              delegate:delegate
                              cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                              otherButtonTitles:nil];
    alertView.tag = tag;
    [alertView show];
}

- (void)showTextFieldAlertWithOkCancelButton:(NSString *)title tag:(NSInteger)tag delegate:(id)delegate
                                defaultValue:(NSString *)defaultValue placeHolder:(NSString *)placeHolder
{
    // Create alert
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:@"\n"
                                                       delegate:delegate
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              otherButtonTitles:NSLocalizedString(@"Ok", nil), nil];
    alertView.tag = tag;
    // Build text field
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 260.0f, 30.0f)];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.tag = 9999;
    tf.placeholder = placeHolder;
    tf.text = defaultValue;

    tf.clearButtonMode = UITextFieldViewModeWhileEditing;

    tf.keyboardType = UIKeyboardTypePhonePad;
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    // Show alert and wait for it to finish displaying
    [alertView show];
    while (CGRectEqualToRect(alertView.bounds, CGRectZero));

    // Find the center for the text field and add it
    CGRect bounds = alertView.bounds;
    tf.center = CGPointMake(bounds.size.width / 2.0f, bounds.size.height / 2.0f - 10.0f);
    [alertView addSubview:tf];
    //    [tf becomeFirstResponder];
}

@end
