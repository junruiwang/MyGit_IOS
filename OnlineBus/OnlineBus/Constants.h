//
//  Constants.h
//  OnlineBus
//
//  Created by jerry on 13-12-4.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//
//  api.shareby.us mapping 42.121.117.61:6068
// URL
#define kBaseURL                       @"http://api.shareby.us/bustime/api"

#define query_bus_line                 [kBaseURL stringByAppendingPathComponent:@"/queryLine"]
#define query_bus_single_line          [kBaseURL stringByAppendingPathComponent:@"/querySingleLine"]
#define query_bus_single_time          [kBaseURL stringByAppendingPathComponent:@"/queryRunSingleLine"]
#define query_bus_station              [kBaseURL stringByAppendingPathComponent:@"/queryStation"]
#define query_station_line             [kBaseURL stringByAppendingPathComponent:@"/queryStationBus"]

#define kCustomButtonHeight		30.0
#define kSampleAdUnitID @"ca-app-pub-3100586685780875/9333793543"
#define kTrackingId  @"UA-39510485-3"
#define RGB(R,G,B) [UIColor colorWithRed:(float)R/255.0 green:(float)G/255.0 blue:(float)B/255.0 alpha:1]
#define kAppStoreUrl @"https://itunes.apple.com/us/app/su-zhou-zai-xian-gong-jiao/id639107014?ls=1&mt=8"

#define FROM_BUSLIST_TO_BUSDETAIL       @"fromBusListToBusDetail"
#define FROM_BUSSTATION_TO_BUSLINE      @"fromBusStationToBusLine"
#define FROM_BUSSTATION_TO_BUSDETAIL    @"fromBusStationToBusDetail"
#define FROM_FAVERATE_TO_BUSDETAIL      @"fromFaverateToBusDetail"
#define FROM_FAVERATE_TO_STATIONBUS     @"fromFaverateToStationBus"
#define FROM_MORE_TO_ABOUTUS            @"fromMoreToAboutUs"

#ifdef DEBUG
#define kLogEnable  YES
#else
#define kLogEnable  NO
#endif

#import "AppDelegate.h"
#define TheAppDelegate  ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define SYSTEM_VERSION [[UIDevice currentDevice].systemVersion doubleValue]
#define RGBCOLOR(R,G,B) [UIColor colorWithRed:(float)R/255.0 green:(float)G/255.0 blue:(float)B/255.0 alpha:1]
