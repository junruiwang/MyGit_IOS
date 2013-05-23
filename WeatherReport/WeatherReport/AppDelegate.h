//
//  AppDelegate.h
//  WeatherReport
//
//  Created by jerry on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSLoadingViewController.h"
#import "LocationInfo.h"
#import "LocationManager.h"
#import "ModelWeather.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) DSLoadingViewController *loadingViewController;
@property (nonatomic, strong) UITabBarController *mainTabBarController;

@property (nonatomic, strong) LocationInfo *locationInfo;
@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) ModelWeather *modelWeather;

- (void)loadLoadingView;
- (void)loadMainView;

@end
