//
//  MyServerIdManager.m
//  IntelligentHome
//
//  Created by jerry on 14-1-22.
//  Copyright (c) 2014年 jerry.wang. All rights reserved.
//

#import "MyServerIdManager.h"
#import "FileManager.h"

@interface MyServerIdManager ()

@end

@implementation MyServerIdManager

- (BOOL)addServerIdToFile:(NSString *) serverId
{
    NSString *path = [FileManager fileCachesPath:@"MyServerInfo.plist"];
    NSMutableArray *serverIdArray = [self readServerIdListFromLocalFile];
    if (serverIdArray == nil) {
        serverIdArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    if ([serverIdArray count] > 0) {
        BOOL hasExist = NO;
        NSUInteger existIndex = 0;
        for (int i=0; i<[serverIdArray count]; i++) {
            NSString *tempServerId = [serverIdArray objectAtIndex:i];
            //本地列表存在serverId，进行标记
            if (tempServerId != nil && [tempServerId isEqualToString:serverId]) {
                hasExist = YES;
                existIndex = i;
                break;
            }
        }
        //调整数组元素的位置
        if (hasExist) {
            if (existIndex > 0) {
                [serverIdArray exchangeObjectAtIndex:0 withObjectAtIndex:existIndex];
            }
        } else {
            [serverIdArray insertObject:serverId atIndex:0];
        }
        //数组长度超过10，移除多余的元素
        if ([serverIdArray count] > 10) {
            [serverIdArray removeLastObject];
        }
    } else {
        [serverIdArray addObject:serverId];
    }
    
    
    return [serverIdArray writeToFile: path atomically:YES];
}

- (NSString *)getCurrentServerId
{
    NSMutableArray *serverIdArray = [self readServerIdListFromLocalFile];
    if (serverIdArray != nil && [serverIdArray count] > 0) {
        return [serverIdArray objectAtIndex:0];
    }
    return @"";
}

- (NSString *)getServerListByJson
{
    NSMutableString *serverListJson = [NSMutableString stringWithString:@"["];
    NSMutableArray *serverIdArray = [self readServerIdListFromLocalFile];
    if (serverIdArray != nil && [serverIdArray count] > 0) {
        if ([serverIdArray count] == 1) {
            [serverListJson appendFormat:@"{\"id\":\"%@\",\"selected\":true}",[serverIdArray objectAtIndex:0]];
        } else {
            for (int i=0; i<[serverIdArray count]; i++) {
                NSString *serverId = [serverIdArray objectAtIndex:i];
                if (i==0) {
                    [serverListJson appendFormat:@"{\"id\":\"%@\",\"selected\":true}",serverId];
                } else {
                    [serverListJson appendFormat:@"{\"id\":\"%@\",\"selected\":false}",serverId];
                }
                
                if (i <([serverIdArray count]-1)) {
                    [serverListJson appendString:@","];
                }
            }
        }
    }
    [serverListJson appendString:@"]"];
    return serverListJson;
}

- (NSMutableArray *)readServerIdListFromLocalFile
{
    NSString *path = [FileManager fileCachesPath:@"MyServerInfo.plist"];
    return [[NSMutableArray alloc] initWithContentsOfFile:path];
}

@end
