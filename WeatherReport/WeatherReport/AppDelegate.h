//
//  AppDelegate.h
//  WeatherReport
//
//  Created by jerry on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSLoadingViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) DSLoadingViewController *loadingViewController;
@property (nonatomic, retain) UITabBarController *mainTabBarController;

- (void)loadLoadingView;
- (void)loadMainView;

@end
