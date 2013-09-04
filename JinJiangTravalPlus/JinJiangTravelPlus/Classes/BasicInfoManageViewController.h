//
//  BasicInfoManageViewController.h
//  JinJiangTravelPlus
//
//  Created by jerry on 13-1-24.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "JJViewController.h"

@protocol BasicInfoManageViewControllerDelegate <NSObject>

- (void)updateSuccessAfterHandle;

@end

@interface BasicInfoManageViewController : JJViewController

@property (nonatomic, weak) IBOutlet UITextField* phoneField;
@property (nonatomic, weak) IBOutlet UITextField* emailField;
@property (nonatomic, strong) UIButton* doneInKeyboardButton;
@property (nonatomic, weak) id<BasicInfoManageViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *mainView;

- (IBAction)hideKeyboard:(id)sender;
- (IBAction)updateBasicInfo:(id)sender;

@end
