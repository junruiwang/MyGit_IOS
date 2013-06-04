//
//  LocationParser.h
//  JinJiangTravalPlus
//
//  Created by 汪君瑞 on 12-11-9.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "Constants.h"
#import "UMSocialControllerService.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "BannerViewController.h"

@interface ShareToSNSManager : NSObject <UMSocialUIDelegate>

@property (nonatomic, assign) BannerViewController *_viewController;

- (void)shareWithActionSheet:(BannerViewController *)controller shareImage:(UIImage *)shareImage shareText:(NSString *)shareText;

- (void)shareWithList:(BannerViewController *)controller shareImage:(UIImage *)shareImage shareText:(NSString *)shareText;

- (void)showAlertMessage:(NSString *)msg;

@end
