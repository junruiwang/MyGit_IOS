//
//  LoginViewController.m
//  ChoiceCourse
//
//  Created by jerry on 12-9-12.
//  Copyright (c) 2012年 jerry. All rights reserved.
//
#import "LoginViewController.h"
#import "CourseViewController.h"
#import "RegexKitLite.h"

@interface LoginViewController ()

- (void)showAlertMessage:(NSString *)msg;
- (void) wirteToFile;
- (BOOL) verifyForm;

@end

@implementation LoginViewController

@synthesize emailTextField;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"小老师登录页面";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login.png"]];
    self.emailTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(IBAction)login
{
    //GA跟踪搜索按钮
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"uiAction" withAction:@"buttonPress" withLabel:@"小老师登录按钮" withValue:nil];
    if ([self verifyForm]) {
        [self wirteToFile];
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}

- (IBAction)backgroundTap:(id)sender
{
    [self.emailTextField resignFirstResponder];
}

- (void)viewDidUnload
{
    self.emailTextField = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    [self.emailTextField release];
    [super dealloc];
}

- (BOOL) verifyForm
{
    NSString *regexString = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSString *emailString = self.emailTextField.text;
    BOOL matched = [emailString isMatchedByRegex:regexString];
    if (!matched) {
        [self showAlertMessage: @"请输入正确的Email地址"];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) wirteToFile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:emailTextField.text forKey:@"user_email_info"];
    [userDefaults synchronize];
}

- (void)showAlertMessage:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"温馨提示"
                              message:msg
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}
@end
