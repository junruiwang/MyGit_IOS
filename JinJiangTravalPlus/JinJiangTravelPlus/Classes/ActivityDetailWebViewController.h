//
//  ActivityDetailWebViewController.h
//  JinJiangTravelPlus
//
//  Created by jerry on 13-7-30.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "JJViewController.h"
#import "ActiveConfig.h"
#import "ShareToSNSManager.h"

@interface ActivityDetailWebViewController : JJViewController <UIWebViewDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) ActiveConfig *config;

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property(nonatomic, strong) ShareToSNSManager *shareToSNSManager;


@property (weak, nonatomic) IBOutlet UIImageView *phone_shadow;
@property (weak, nonatomic) IBOutlet UIImageView *shakeLeft;
@property (weak, nonatomic) IBOutlet UIImageView *shakeRight;
@property (weak, nonatomic) IBOutlet UIImageView *shadow;
@property (weak, nonatomic) IBOutlet UIImageView *ruleBack;
@property (weak, nonatomic) IBOutlet UIImageView *phone;
@property (weak, nonatomic) IBOutlet UIImageView *ribbon;
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;

@property (weak, nonatomic) IBOutlet UIView *awardResult;
@property (weak, nonatomic) IBOutlet UIImageView *getAward;
@property (weak, nonatomic) IBOutlet UIImageView *notAward;
@property (weak, nonatomic) IBOutlet UILabel *getAwardLabel;
@property (weak, nonatomic) IBOutlet UILabel *getAwardDescription;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *ribbonLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

@property (weak, nonatomic) IBOutlet UIView *productResultView;
@property (weak, nonatomic) IBOutlet UITextView *productDescription;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;



@property (weak, nonatomic) IBOutlet UIView *shakeView;
@end
