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

@interface UserFeedbackController : JJViewController <UIAlertViewDelegate, UITextFieldDelegate, UITextViewDelegate, GDataXMLParserDelegate>
{
    UILabel* placeholderLabel;
    UITapGestureRecognizer* tapHide;
}

@property(nonatomic, strong)UserFeedbackParser* userFeedbackParser;

@property(nonatomic, weak) IBOutlet UIView *bgView;
@property(nonatomic, weak) IBOutlet UIImageView *contentImageView;
@property(nonatomic, weak) IBOutlet UIImageView *dashedImageView;

@property(nonatomic, weak) IBOutlet UITextView* feedbackContent;
@property(nonatomic, weak) IBOutlet UITextField* contactPhone;
@property(nonatomic, weak) IBOutlet UITextField* contactEmail;

@end
