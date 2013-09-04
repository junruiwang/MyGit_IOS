//
//  LoginViewController.h
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-14.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "JJViewController.h"
#import "LoginParser.h"
#import "UserInfo.h"
#import "LoginSwitchView.h"
#import "HotelPriceConfirmForm.h"

#pragma mark - LoginViewControllerDelegate

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginAfterHandle;

@end

#pragma mark - LoginViewController

@interface LoginViewController : JJViewController <LoginSwitchViewDelegate>

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, weak) IBOutlet UITextField *userNameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet LoginSwitchView *saveAccountSwitchView;
@property (weak, nonatomic) IBOutlet LoginSwitchView *autoLoginSwitchView;
@property (nonatomic, strong) HotelPriceConfirmForm *hotelPriceConfirmForm;

@property(nonatomic, strong) LoginParser *loginParser;

- (IBAction)editingDidNext:(id)sender;
- (IBAction)resignEditing:(id)sender;
- (IBAction)loginButtonClick;

@end
