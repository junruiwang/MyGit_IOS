//
//  LoginViewController.h
//  HomeFurnishing
//
//  Created by jrwang on 14-12-11.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

@property(nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property(nonatomic, weak) IBOutlet UITextField *usernameField;
@property(nonatomic, weak) IBOutlet UITextField *passwordField;
@property(nonatomic, weak) IBOutlet UILabel *serverIdLabel;
@property(nonatomic, weak) IBOutlet UIButton *checkBtn;

-(IBAction)cancelLoginClicked:(id)sender;
-(IBAction)checkButtonClicked:(id)sender;
-(IBAction)loginButtonClicked:(id)sender;

-(IBAction)dismissCurrentKeyboard:(id)sender;

@end
