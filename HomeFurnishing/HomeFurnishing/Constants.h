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
#define kSceneListURL                  @"http://115.29.147.77:8080/scene/list.dhtml"
#define kUserLoginURL                  @"http://115.29.147.77:8080/user/validate.dhtml"

#define kUdpBroadcastHost    @"224.0.0.1"
#define kUdpBroadcastPort    5225
#define kUdpSocketPort       58129
#define kTcpSocketPort       8868

#define kClientVersion @"1.1"
#define kHtmlFinishLoadFunction @"onAppLoad"
#define kTcpNotifyFunction @"onReceiveMessage"
#define kUpperOk @"OK"
#define kServerIdList @"getserverlist://"
#define kChangeServer @"changeserver://"
#define kSeparateFlag @"://"

#define kAddSceneModeButton  @"添加情景"
#define kSecretKey    @"2F7BD8C4-D337-4978-9443-852452C6AF57"

#ifdef DEBUG
#define kLogEnable  YES
#else
#define kLogEnable  NO
#endif

#define TheAppDelegate  ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]