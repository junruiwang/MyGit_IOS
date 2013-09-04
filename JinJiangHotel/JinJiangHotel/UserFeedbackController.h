//
//  UserFeedbackController.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 13-1-8.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserFeedbackParser.h"
#import "Constants.h"
#import "JJViewController.h"

@interface UserFeedbackController : JJViewController <UIAlertViewDelegate, UITextFieldDelegate, UITextViewDelegate, GDataXMLParserDelegate>
{
    
    UITapGestureRecognizer* tapHide;
}

@property(nonatomic, strong)UserFeedbackParser* userFeedbackParser;

//--------------------------------------------------------------------

@property (nonatomic, weak) IBOutlet UIView *containerBgView;

@property (nonatomic, weak) IBOutlet UIView *bodyView;

@property (nonatomic, weak) IBOutlet UIView *contactView;

@property (nonatomic, weak) IBOutlet UIView *tilingView;

@property (nonatomic, weak) IBOutlet UIView *bottomView;

@property (nonatomic, weak) IBOutlet UILabel* placeholderLabel;

@property(nonatomic, weak) IBOutlet UITextView* feedbackContent;

@property(nonatomic, weak) IBOutlet UITextField* contactPhone;

@property(nonatomic, weak) IBOutlet UITextField* contactEmail;

@property (nonatomic, weak) IBOutlet UIButton *testBtn;
//--------------------------------------------------------------------

@end
