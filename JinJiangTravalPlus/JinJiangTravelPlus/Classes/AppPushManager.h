//
//  AppPushManager.h
//  JinJiang
//
//  Created by jerry on 12-7-18.
//
//

#import <Foundation/Foundation.h>
#import "ApnsDeviceTokenParser.h"

@interface AppPushManager : NSObject<GDataXMLParserDelegate>

- (void) registerForRemoteNotification;
- (void) processRemoteNotification:(NSDictionary *)notification;
- (void) saveRemoteDeviceToken: (NSString *) remoteDeviceToken;
- (void) saveRemoteDeviceTokenAfterLogin;

@end
