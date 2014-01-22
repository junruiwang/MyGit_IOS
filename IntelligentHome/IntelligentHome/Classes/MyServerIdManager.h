//
//  MyServerIdManager.h
//  IntelligentHome
//
//  Created by jerry on 14-1-22.
//  Copyright (c) 2014年 jerry.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyServerIdManager : NSObject

- (BOOL)addServerIdToFile:(NSString *) serverId;
- (NSString *)getCurrentServerId;

@end
