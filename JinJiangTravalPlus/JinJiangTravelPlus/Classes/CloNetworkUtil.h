//
//  CloNetworkUtil.h
//  JinJiangTravelPlus
//
//  Created by jerry on 13-3-12.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface CloNetworkUtil : NSObject

@property(nonatomic, strong) Reachability *reachability;

- (BOOL)getNetWorkStatus;
- (NetworkStatus)getNetWorkType;

@end
