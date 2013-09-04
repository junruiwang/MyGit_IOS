//
//  jinjiangAppDelegate.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-26.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "jinjiangAppDelegate.h"

#import "jinjiangViewController.h"

#import "RootWindowUI.h"

#import "MainNC.h"

#import "MemoryView.h"

@implementation jinjiangAppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    measurement = [[AppMeasurement alloc] init];
    measurement.account = @"jinjiang-jjplus-ipad-prod";
    measurement.trackingServer = @"jinjiang.d1.sc.omtrdc.net";
    measurement.dc = @"122"; //one of the two Adobe data collection servers, default is 112
    //    measurement.trackOffline = YES; //this may cause data lost
    measurement.useBestPractices = YES;
#ifndef __OPTIMIZE__
    measurement.debugTracking = YES;
#endif
    //clear cache
    BOOL willClearCache = [[NSUserDefaults standardUserDefaults] boolForKey:@"cache"];
    if (willClearCache) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:MAGZINE_PATH error:nil];
        [fileManager removeItemAtPath:JJ360_PATH error:nil];
        [fileManager removeItemAtPath:MOVIE_PATH error:nil];
    }
    
    // Override point for customization after application launch.
    
    //NSLog(@"::::%f:::%f::::%f",pow(2,1),pow(2,2),pow(2,3));
    
    //self.window.rootViewController = self.viewController;
    
    
    
    window=[RootWindowUI sharedInstance];
    //window=[[UIWindow alloc] initWithFrame:FULLRECT];
   
    [window makeKeyAndVisible];
    
    //[MemoryView addTrack:window frame:CGRectMake(0, 0, 220, 22)];
    //[rvc release];
    //self.window.multipleTouchEnabled=YES;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    //[[jinjiangViewController sharedInstance] release];
    RemoveRelease(window);
    //[[jinjiangViewController sharedInstance] release];
    [super dealloc];
}

@end
