//
//  WebViewController.h
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 12-12-24.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJViewController.h"

@interface WebViewController : JJViewController <UIWebViewDelegate, UIAlertViewDelegate>

@property (nonatomic, copy) NSString *url;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end
