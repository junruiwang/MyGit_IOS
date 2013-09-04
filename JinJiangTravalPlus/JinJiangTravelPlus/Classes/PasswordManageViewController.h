//
//  PasswordManageViewController.h
//  JinJiangTravelPlus
//
//  Created by jerry on 13-2-4.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "JJViewController.h"
#import "UpdatePasswordParser.h"

@protocol PasswordManageViewControllerDelegate <NSObject>

- (void)changedPasswordAfterHandle;

@end

@interface PasswordManageViewController : JJViewController

@property (nonatomic, weak) IBOutlet UITextField* oldPasswordField;
@property (nonatomic, weak) IBOutlet UITextField* currentPasswordField;
@property (nonatomic, weak) IBOutlet UITextField* confPasswordField;
@property (nonatomic, weak) id<PasswordManageViewControllerDelegate> delegate;
@property (nonatomic, strong) UpdatePasswordParser* updatePasswordParser;
@property (weak, nonatomic) IBOutlet UIView *formView;

- (IBAction)hideKeyboard:(id)sender;
- (IBAction)changePassword:(id)sender;


@end
