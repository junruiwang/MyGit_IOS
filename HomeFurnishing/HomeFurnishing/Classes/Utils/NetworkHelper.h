//
//  NetworkHelper.h
//  IntelligentHome
//
//  Created by jerry on 13-12-11.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface NetworkHelper : NSObject

+ (NSString *)fetchSSIDInfo;

@end
