//
//  Constants.h
//  IntelligentHome
//
//  Created by jerry on 13-12-11.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//

#define kHostAddress                   @"115.29.147.77"
#define kBaseURL                       @"http://115.29.147.77:8080"
#define kAliyunURL                     @"http://115.29.147.77/queryFamilyServer.dhtml"

#define kUdpBroadcastHost    @"224.0.0.1"
#define kUdpBroadcastPort    5225
#define kUdpSocketPort       58129
#define kTcpSocketPort       8868

#define kClientVersion @"1.0"
#define kHtmlFinishLoadFunction @"onAppLoad"
#define kTcpNotifyFunction @"onReceiveMessage"
#define kUpperOk @"OK"
#define kServerIdList @"getserverlist://"
#define kChangeServer @"changeserver://"
#define kSeparateFlag @"://"

#ifdef DEBUG
#define kLogEnable  YES
#else
#define kLogEnable  NO
#endif

#define TheAppDelegate  ((AppDelegate *)[UIApplication sharedApplication].delegate)
