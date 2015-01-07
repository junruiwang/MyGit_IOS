//
//  CloNetworkUtil.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-3-12.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "CloNetworkUtil.h"

@implementation CloNetworkUtil

- (id)init
{
    if (self = [super init])
    {
        _reachability = [Reachability reachabilityForInternetConnection];
    }
    
    return self;
}

- (BOOL)getNetWorkStatus
{
    if ([self.reachability currentReachabilityStatus] == NotReachable) {
        return NO;
    }else {
        return YES;
    }
}

- (NetworkStatus)getNetWorkType
{
    return [self.reachability currentReachabilityStatus];
}

@end
