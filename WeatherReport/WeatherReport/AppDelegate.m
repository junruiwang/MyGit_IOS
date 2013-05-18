//
//  AppDelegate.m
//  WeatherReport
//
//  Created by jerry on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "IndexViewController.h"
#import "DSTwoViewController.h"
#import "DSThreeViewController.h"
#import "DSFourViewController.h"
#import "DSFiveViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    //设置顶部状态栏背景色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    //获取屏幕尺寸
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    if (screenRect.size.height > 500){
        [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:USER_DEVICE_5];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO   forKey:USER_DEVICE_5];
    }
    //设置启动画面
    [self loadLoadingView];
    
    //启动定位
    self.locationManager = [[LocationManager alloc] init];
    //init base data
    self.locationInfo = [[LocationInfo alloc] init];
    
    [self.window makeKeyAndVisible];
    
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
    //Locating again
    self.locationManager.isLocationOver = NO;
    [self.locationManager startLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Custom methods

- (void)loadLoadingView
{
    self.loadingViewController = [[DSLoadingViewController alloc] init];
    [self.window addSubview:self.loadingViewController.view];
}

- (void)loadMainView
{
    IndexViewController *indexViewController = [[IndexViewController alloc] init];
    UINavigationController *indexNavigationController = [[UINavigationController alloc] initWithRootViewController:indexViewController];
    indexNavigationController.navigationBar.barStyle = UIBarStyleBlack;
    indexNavigationController.tabBarItem.title = @"one";
    indexNavigationController.tabBarItem.image = [UIImage imageNamed:@"load_1.png"];
    
    DSTwoViewController *twoViewController = [[DSTwoViewController alloc] init];
    UINavigationController *twoNavigationController = [[UINavigationController alloc] initWithRootViewController:twoViewController];
    twoNavigationController.navigationBar.barStyle = UIBarStyleBlack;
    twoNavigationController.tabBarItem.title = @"two";
    twoNavigationController.tabBarItem.image = [UIImage imageNamed:@"load_2.png"];
    
    DSThreeViewController *threeViewController = [[DSThreeViewController alloc] init];
    UINavigationController *threeNavigationController = [[UINavigationController alloc] initWithRootViewController:threeViewController];
    threeNavigationController.navigationBar.barStyle = UIBarStyleBlack;
    threeNavigationController.tabBarItem.title = @"three";
    threeNavigationController.tabBarItem.image = [UIImage imageNamed:@"load_3.png"];
    
    DSFourViewController *fourViewController = [[DSFourViewController alloc] init];
    UINavigationController *fourNavigationController = [[UINavigationController alloc] initWithRootViewController:fourViewController];
    fourNavigationController.navigationBar.barStyle = UIBarStyleBlack;
    fourNavigationController.tabBarItem.title = @"four";
    fourNavigationController.tabBarItem.image = [UIImage imageNamed:@"load_4.png"];
    
    DSFiveViewController *fiveViewController = [[DSFiveViewController alloc] init];
    UINavigationController *fiveNavigationController = [[UINavigationController alloc] initWithRootViewController:fiveViewController];
    fiveNavigationController.navigationBar.barStyle = UIBarStyleBlack;
    fiveNavigationController.tabBarItem.title = @"five";
    fiveNavigationController.tabBarItem.image = [UIImage imageNamed:@"load_5.png"];
    
    self.mainTabBarController = [[UITabBarController alloc] init];
    self.mainTabBarController.viewControllers = [NSArray arrayWithObjects:
                                                 indexNavigationController,
                                                 twoNavigationController,
                                                 threeNavigationController,
                                                 fourNavigationController,
                                                 fiveNavigationController, nil];
    
    [self.window addSubview:self.mainTabBarController.view];
    [self.window bringSubviewToFront:self.loadingViewController.view];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(loadingViewAnimationDone)];
    [UIView setAnimationDuration:2];
    self.loadingViewController.view.alpha = 0;
    [UIView commitAnimations];
}

- (void)loadingViewAnimationDone
{
    self.loadingViewController = nil;
}

@end
