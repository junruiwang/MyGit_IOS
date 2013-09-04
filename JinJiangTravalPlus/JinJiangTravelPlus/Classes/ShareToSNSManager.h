//
//  ShareToSNSManager.h
//  JinJiang
//
//  Created by Li Peng on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "Constants.h"
#import "UMSocialControllerService.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"

@interface ShareToSNSManager : NSObject <UMSocialUIDelegate>

@property (nonatomic, assign) JJViewController *_viewController;

- (void)shareWithActionSheet:(JJViewController *)controller shareImage:(UIImage *)shareImage shareText:(NSString *)shareText;

- (void)shareWithList:(JJViewController *)controller shareImage:(UIImage *)shareImage shareText:(NSString *)shareText;

- (void)showAlertMessage:(NSString *)msg;

@end
