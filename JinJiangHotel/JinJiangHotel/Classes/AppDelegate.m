//
//  AppDelegate.m
//  JinJiangHotel
//
//  Created by jerry on 13-8-12.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "AppDelegate.h"
#import "DeviceInfo.h"
#import "Constants.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // 取得 iPhone 支持的所有语言设置
    NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
    NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
    NSLog ( @"%@" , languages);
    
    NSString *str = NSLocalizedString(@"demo", @"");
    NSLog(@"%@", str);
    
    NSString *device = [DeviceInfo platformName];
    NSLog(@"%@", device);
    
    //初始化用户信息
    self.userInfo = [[UserInfo alloc] init];
    //判定是否自动登录
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:kRestoreAutoLogin];
    if (userData != nil) {
        self.userInfo = [UserInfo unarchived:userData];
    }
    
    self.hotelSearchForm = [[HotelSearchForm alloc] init];
    
    self.locationManager = [[LocationManager alloc] init];
    self.locationInfo = [[LocationInfo alloc] init];
    
    self.sendShotMsgTime = 0;
    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_ORDER_ALL] != YES)
//    {   [[NSUserDefaults standardUserDefaults] setBool:NO   forKey:USER_ORDER_ALL];  }
//    
//    if ([[DeviceInfo platformName] rangeOfString:@"iPhone 5"].length > 0)
//    {   [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:USER_DEVICE_5];  }
//    else
//    {   [[NSUserDefaults standardUserDefaults] setBool:NO   forKey:USER_DEVICE_5];  }
//    
//    //保存系统版本号
//    [[NSUserDefaults standardUserDefaults] setFloat:[[UIDevice currentDevice] systemVersion].floatValue forKey:USER_DEVICE_VERSION];
//    
//    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //Locating again
    TheAppDelegate.locationInfo.cityName = nil;
    self.locationManager.isLocationOver = NO;
    [self.locationManager startLocation];
    
    KalDate *today = [KalDate dateFromNSDate:[NSDate date]];
    if ([TheAppDelegate.hotelSearchForm.checkinDate compare:today] == NSOrderedAscending) {
        TheAppDelegate.hotelSearchForm.checkinDate = today;
        TheAppDelegate.hotelSearchForm.checkoutDate= [today getNextKalDate];
        TheAppDelegate.hotelSearchForm.nightNums = 1;
    }
}

- (void)timerStart
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:self repeats:YES];
}

- (void) timerFired  :(id)sender
{
    NSLog(@"time is %d", TheAppDelegate.sendShotMsgTime);
    if (self.sendShotMsgTime <= 0 )
    {
        [self.timer invalidate];
        self.sendShotMsgTime = TIME;
        return;
    }
    
    TheAppDelegate.sendShotMsgTime --;
    
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
