//
//  ShareToSNSManager.m
//  JinJiang
//
//  Created by Li Peng on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShareToSNSManager.h"
#import "UIViewController+Categories.h"


@implementation ShareToSNSManager

@synthesize _viewController;

- (void)showAlertMessage:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"信息提示", nil)
                              message:msg
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                              otherButtonTitles:nil];
    [alertView show];
}

//ActionSheet方式展示分享平台
- (void)shareWithActionSheet:(JJViewController *)controller shareImage:(UIImage *)shareImage shareText:(NSString *)shareText
{
    _viewController = controller;
    
    //设置微信图文分享
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    [UMSocialData defaultData].extConfig.appUrl = kAppStoreUrl;
    
    //设置分享平台
    NSArray *snsNames = @[UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToQzone,UMShareToWechat,UMShareToEmail,UMShareToSms];
    
    [UMSocialSnsService presentSnsIconSheetView:_viewController appKey:kUMengShareKey shareText:shareText shareImage:shareImage shareToSnsNames:snsNames delegate:self];
}

//table list方式展示分享平台
- (void)shareWithList:(JJViewController *)controller shareImage:(UIImage *)shareImage shareText:(NSString *)shareText
{
    _viewController = controller;
    
    //设置微信图文分享
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    [UMSocialData defaultData].extConfig.appUrl = kAppStoreUrl;
    
    //设置分享平台
    NSArray *snsNames = @[UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToQzone,UMShareToWechat,UMShareToEmail,UMShareToSms];
    
    [UMSocialSnsService presentSnsController:_viewController appKey:kUMengShareKey shareText:shareText shareImage:shareImage shareToSnsNames:snsNames delegate:self];
    
}


#pragma mark - UMSocialUIDelegate method

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`response`的`viewControllerType`来得到页面类型
    if (response.viewControllerType == UMSViewControllerShareEdit) {
        //根据`responseCode`得到发送结果,如果分享成功
        if(response.responseCode == UMSResponseCodeSuccess)
        {
            //得到分享到的微博平台名
            NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        }
    }
}

@end
