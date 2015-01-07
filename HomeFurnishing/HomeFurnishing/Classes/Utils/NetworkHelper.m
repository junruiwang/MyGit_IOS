//
//  NetworkHelper.m
//  IntelligentHome
//
//  Created by jerry on 13-12-11.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//

#import "NetworkHelper.h"

@implementation NetworkHelper

+ (NSString *)fetchSSIDInfo
{
    NSArray *ifs = (__bridge_transfer id) CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    if (info) {
        NSDictionary *ssidDict = (NSDictionary *)info;
        NSString *ssid = [[ssidDict objectForKey:@"SSID"] lowercaseString];
        return ssid;
    }
    
    return nil;
}

@end
