//
//  JJAppDelegate.h
//  JinJiangTravelPlus
//
//  Created by Leon on 11/9/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
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
#import "ClientVersionManager.h"
#import "ClientVersion.h"
#import "IndexViewController.h"
#import "AppPushManager.h"
#import "RetrievePwdViewController.h"

typedef enum {
    JJCustomTypeBill = 0,
    JJCustomTypeMember = 1,
    JJCustomTypeShakeAward = 3,
    JJCustomTypeActivity = 4
} JJCustomEnumType;

@interface JJAppDelegate : UIResponder <UIApplicationDelegate>


@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) LocationInfo *locationInfo;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) HotelSearchForm *hotelSearchForm;
@property (nonatomic, strong) ClientVersion *clientVersion;

@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) ClientVersionManager *clientVersionManager;
@property (nonatomic, strong) AppPushManager *pushManager;
@property (nonatomic) double savedLatitude;
@property (nonatomic) double savedLongitude;
@property (nonatomic) BOOL enterdLBS;
@property (nonatomic, assign) JJCustomEnumType customEnumType;
@property (nonatomic, strong) id<TimerDelegate> delegate;
@property (nonatomic) int sendShotMsgTime;
@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) id<GAITracker> tracker;
@property(nonatomic,copy) NSString *shakeAwardDate;


- (void) timerFired :(NSTimer *)timer;

//- (void) afterTimerFired;

@end
