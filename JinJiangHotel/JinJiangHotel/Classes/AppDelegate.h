//
//  AppDelegate.h
//  JinJiangHotel
//
//  Created by jerry on 13-8-12.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "UMSocialData.h"
#import "UMSocialSnsService.h"
#import "WXApi.h"
#import "LocationInfo.h"
#import "UserInfo.h"
#import "LocationManager.h"
#import "HotelSearchForm.h"

typedef NS_ENUM(NSInteger, JJHLoginEnterance) {
    JJHDefaultLogin,
    JJHHotelDetailLogin
};

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) LocationInfo *locationInfo;
@property (nonatomic, strong) UserInfo *userInfo;

@property (nonatomic, strong) HotelSearchForm *hotelSearchForm;
@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic) double savedLatitude;
@property (nonatomic) double savedLongitude;
@property (nonatomic) BOOL enterdLBS;
@property (nonatomic) int sendShotMsgTime;
@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) id<GAITracker> tracker;

@property (nonatomic) JJHLoginEnterance loginEnterance;

- (void)timerStart;
@end
