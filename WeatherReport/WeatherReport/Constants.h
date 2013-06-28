//
//  Constants.h
//  WeatherReport
//
//  Created by 汪君瑞 on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#ifndef WeatherReport_Constants_h
#define WeatherReport_Constants_h
#endif

#define USER_DEVICE_5 @"USER_DEVICE_5_WEATHER_REPORT"
//baidu map key
#define kBaiduKey  @"F1d3f34adb86e328411c49a03147ae1a"
//UMeng Share Key
#define kUMengShareKey @"51cd879656240ba37d063d74"
#define kWXShareKey @"wx35479f4cd823954f"
#define kTrackingId  @"UA-39510485-4"
//appstore info
#define kAppStoreUrl @"https://itunes.apple.com/us/app/ku-lu-tian-qi-tian-qi-yu-bao/id667928959?ls=1&mt=8"
#define kCommentUrl @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=667928959"

#define kLogEnable NO

#define RGBCOLOR(R,G,B) [UIColor colorWithRed:(float)R/255.0 green:(float)G/255.0 blue:(float)B/255.0 alpha:1]

#define TheAppDelegate  ((AppDelegate *)[UIApplication sharedApplication].delegate)

#import "ServerAddressManager.h"