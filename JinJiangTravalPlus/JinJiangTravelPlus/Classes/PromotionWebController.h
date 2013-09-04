//
//  PromotionWebController.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 13-1-6.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface PromotionWebController : JJViewController<UIWebViewDelegate>

@property(nonatomic, strong)NSURL* url;
@property(nonatomic, strong)UIWebView* web;

@end
