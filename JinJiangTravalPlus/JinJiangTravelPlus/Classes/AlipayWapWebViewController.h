//
//  AlipayWapWebViewViewController.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 3/15/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "AlipayForm.h"

#define callBackUrl [kBaseURL stringByAppendingFormat:@"/payment/callBackAliPay"]

@interface AlipayWapWebViewController : WebViewController

@property (nonatomic,strong) UIAlertView *confirmAlertView;

@property (nonatomic,copy) NSString *orderNo;

@property (nonatomic,strong) UIWebView *loadWebView;

@property (nonatomic,strong) NSString *htmlBody;

@property (nonatomic,strong) NSString *sourceControlelr;


-(id)initWithUrl:(NSString *) urlStr;
-(void)loadRequest;
-(void)buildAlipayWapUrl:(AlipayForm*) form;

@end
