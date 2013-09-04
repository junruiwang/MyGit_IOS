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
#import "CellButton.h"
#import "UserInfo.h"
#import "ActiveConfig.h"


#pragma mark - LoginViewControllerDelegate

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginAfterHandle;

@end

#pragma mark - LoginViewController

@interface LoginViewController : JJViewController <UIActionSheetDelegate>

#pragma mark @property

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSString *activityUrl;
@property (nonatomic, strong) ActiveConfig *activeConfig;


@property (nonatomic, weak) IBOutlet UITextField *userNameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *saveAccountBtn;
@property (nonatomic, weak) IBOutlet UIButton *autoLoginBtn;
@property (nonatomic, weak) IBOutlet UIButton *activationBtn;
@property (nonatomic, weak) IBOutlet UIButton *leftTabButton;
@property (nonatomic, weak) IBOutlet UIButton *rightTabButton;
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UILabel *jjInnLabel;
@property (nonatomic, weak) IBOutlet UIView *leftTabView;
@property (nonatomic, weak) IBOutlet UIView *rightTabView;
@property (nonatomic, weak) IBOutlet UIControl *saveAccountView;
@property (nonatomic, weak) IBOutlet UIControl *autoLoginView;
@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;

@property(nonatomic, strong) LoginParser *loginParser;


@property (nonatomic, weak) IBOutlet UIView *top_view;

@property (nonatomic, weak) IBOutlet UIView *main_view;

@property (nonatomic, weak) IBOutlet UIView *main_view_line1;

@property (nonatomic, weak) IBOutlet UIView *main_view_line2;

@property (nonatomic, weak) IBOutlet UIView *activation_view_line1;

#pragma mark @method

- (IBAction)tabTapped:(id)sender;
- (IBAction)checkboxViewTapped:(id)sender;
- (IBAction)checkboxClicked:(UIButton *)btn;
- (IBAction)editingDidNext:(id)sender;
- (IBAction)resignEditing;
- (IBAction)loginButtonClick;
- (IBAction)activationBtnClicked:(id)sender;

@end
