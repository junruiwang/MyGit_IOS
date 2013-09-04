//
//  ActivationViewController.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-18.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivateJJInnMemberParser.h"
#import "ActivationTypeController.h"
#import "JJInnRegisterParser.h"

@interface ActivationViewController : JJViewController<UITextFieldDelegate, ActivationTypeDelegate,
                                                       UIAlertViewDelegate, UIActionSheetDelegate, GDataXMLParserDelegate>
{
    BOOL hasNothing;
    unsigned int index, temp;
    ConditionView* _conditionView;
    ActivationTypeController* _activationTypeController;
    UITapGestureRecognizer* tapHide;
}
@property(nonatomic, strong)NSString* userID;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numbTextField;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property(nonatomic, strong)UIButton* typeButton;
@property(nonatomic, strong)UIButton* loginButton;
@property(nonatomic, strong)UIButton* phoneButton;
@property(nonatomic, strong)UITextField* phoneTextField;
@property(nonatomic, strong)UIView* avtivationResultView;
@property(nonatomic, strong)UITextView* activeResultText;
@property(nonatomic, strong)ConditionView* conditionView;
@property(nonatomic, strong)ActivationTypeController* activationTypeController;

@property(nonatomic, strong)NSArray* typeArray;

@property(nonatomic, strong)NSMutableArray* identityTypeList;
@property(nonatomic, strong)NSString* activateParams;
@property(nonatomic, strong)NSString* identityType;
@property(nonatomic, strong)ActivateJJInnMemberParser* activateJJInnMemberParser;
@property(nonatomic, strong)JJInnRegisterParser* jjInnRegisterParser;
@property(nonatomic, strong)NSString* phoneNumber;

@end
