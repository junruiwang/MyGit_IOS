//
//  JJAppDelegate.m
//  JinJiangTravelPlus
//
//  Created by Leon on 11/9/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "JJAppDelegate.h"
#import "Constants.h"
#import "AppMeasurement.h"
#import "UMAnalyticManager.h"
#import "AlixPay.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"

@implementation JJAppDelegate

@synthesize savedLatitude, savedLongitude, enterdLBS;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //首次加载延长Launch image的时长
    [NSThread sleepForTimeInterval:1.0];
    //去掉红色气泡
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //start location
    self.enterdLBS = NO;
    self.locationManager = [[LocationManager alloc] init];
    //init base info
    self.locationInfo = [[LocationInfo alloc] init];
    self.userInfo = [[UserInfo alloc] init];
    self.hotelSearchForm = [[HotelSearchForm alloc] init];
    self.clientVersionManager = [[ClientVersionManager alloc] init];
    //判定是否自动登录
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:kRestoreAutoLogin];
    if (userData != nil) {
        self.userInfo = [UserInfo unarchived:userData];
    }
    //获取服务器版本信息
    [self.clientVersionManager downloadData];
    
    //APNS消息推送，保存用户Token值
    self.pushManager = [[AppPushManager alloc] init];
    [self.pushManager registerForRemoteNotification];

    [UMAnalyticManager initUMAnalytic];
    [UMAnalyticManager monitorViewPage:@"启动应用"];
    
    // Initialize Google Analytics with a 120-second dispatch interval.
    [GAI sharedInstance].debug = NO;
    [GAI sharedInstance].dispatchInterval = 120;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_ORDER_ALL] != YES)
    {   [[NSUserDefaults standardUserDefaults] setBool:NO   forKey:USER_ORDER_ALL];  }

    if ([[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height > 500)
    {   [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:USER_DEVICE_5];  }
    else
    {   [[NSUserDefaults standardUserDefaults] setBool:NO   forKey:USER_DEVICE_5];  }
    
    //保存系统版本号
    [[NSUserDefaults standardUserDefaults] setFloat:[[UIDevice currentDevice] systemVersion].floatValue forKey:USER_DEVICE_VERSION];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.sendShotMsgTime = 60;
    
    //友盟社会化分享初始化
    [UMSocialData setAppKey:kUMengShareKey];
    [UMSocialData openLog:kLogEnable];
    //向微信注册
    [WXApi registerApp:kWXShareKey];
    
    return YES;
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userinfo
{
    if (application.applicationState == UIApplicationStateInactive) {
        [self.pushManager processRemoteNotification:userinfo];
    }
}

// Retrieve the device token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    [self.pushManager saveRemoteDeviceToken:token];
}

// Provide a user explanation for when the registration fails
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *statusMessage = [[UIApplication sharedApplication] enabledRemoteNotificationTypes] ? @"Notifications were active for this application" : @"Remote notifications were not active for this application";

	NSString *status = [NSString stringWithFormat:@"%@\nRegistration failed.\n\nError: %@", statusMessage, [error localizedDescription]];
    NSLog(@"Error in registration. Error: %@", status);
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //Locating again
    TheAppDelegate.locationInfo.cityName = nil;
    self.locationManager.isLocationOver = NO;
    [self.locationManager startLocation];
    //判定残留日期是否小于当前日期
    KalDate *today = [KalDate dateFromNSDate:[NSDate date]];
    if ([TheAppDelegate.hotelSearchForm.checkinDate compare:today] == NSOrderedAscending) {
        TheAppDelegate.hotelSearchForm.checkinDate = today;
        TheAppDelegate.hotelSearchForm.checkoutDate= [today getNextKalDate];
        TheAppDelegate.hotelSearchForm.nightNums = 1;
    }
    //友盟新浪微博支持SSO方式授权
    [UMSocialSnsService  applicationDidBecomeActive];
    //去掉红色气泡
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//微信分享完成后，跳回你原来应用
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"Host:%@", [url host]);
    NSLog(@"Query:%@", [url query]);
    NSLog(@"sourceApplication:%@", sourceApplication);
    
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    
    if ([sourceApplication rangeOfString:@"com.alipay"].location != NSNotFound) {
        [self parseURL:url application:application];
        return YES;
    }
    
    if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    
    return YES;
}

- (void) timerFired  :(NSTimer *)timer 
{
    [self.delegate timerFired : timer];
}

- (void)parseURL:(NSURL *)url application:(UIApplication *)application {
	AlixPay *alixpay = [AlixPay shared];
	AlixPayResult *result = [alixpay handleOpenURL:url];
	if (result) {
        
        
        switch (result.statusCode) {
            case 9000:
            {
                /*
                 *用公钥验证签名
                 */
                id<DataVerifier> verifier = CreateRSADataVerifier([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA public key"]);
                if ([verifier verifyString:result.resultString withSign:result.signString]) {
                    if ([result.resultString rangeOfString:@"IOS用户购买享卡"].location != NSNotFound) {
                        
                        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"购买享卡"
                                                                        withAction:@"支付宝客户端购买享卡"
                                                                         withLabel:@"支付宝客户端购买享卡"
                                                                         withValue:nil];
                        [UMAnalyticManager eventCount:@"支付宝客户端购买享卡完成" label:[NSString stringWithFormat:@"支付宝客户端购买享卡完成"]];
                        
                        //推送通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClientBuyCardFinished" object:self userInfo:nil];
                        
                        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                             message:@"支付成功"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                        [alertView show];
                    }else if([result.resultString rangeOfString:@"享卡会员手机续费"].location != NSNotFound){
                        [UMAnalyticManager eventCount:@"享卡续费支付完成" label:@"支付宝客户端享卡续费支付完成"];
                        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"享卡续费支付完成"
                                                                        withAction:@"支付宝客户端支付"
                                                                         withLabel:@"支付宝客户端享卡续费支付完成"
                                                                         withValue:nil];
                        //推送通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClientAlipayRenewCardFinished" object:self userInfo:nil];
                    }else {
                        //推送通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClientAlipayFinished" object:self userInfo:nil];
                        
                        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                             message:@"支付成功"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                        [alertView show];
                    }
                } else { //验签错误
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                         message:@"支付失败，请稍后再试或选择其他支付方式"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                    [alertView show];
                }
                break;
            }
            case 4000:
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"支付失败，请稍后再试或选择其他支付方式"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case 4003:
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"支付失败，该用户绑定的支付宝账户被冻结或不允许支付"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case 6000:
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"支付失败，请稍后再试或选择其他支付方式"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case 6001:
            {
                //不做任何提示操作
                break;
            }
            default:
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"支付失败，请稍后再试或选择其他支付方式"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                [alertView show];
                break;
            }
        }
		
	}
}

@end
