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
    NSString *tempServerId = [self readServerIdFromLocalFile];
    if (tempServerId != nil && [tempServerId isEqualToString:serverId]) {
        return YES;
    }
    
    NSString *path = [FileManager fileCachesPath:@"MyServerInfo.plist"];
    NSError *error = nil;
    return [serverId writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

- (NSString *)getCurrentServerId
{
    NSString *serverId = [self readServerIdFromLocalFile];
    if (serverId == nil) {
        serverId = @"";
    }
    return serverId;
}

- (NSString *)readServerIdFromLocalFile
{
    NSString *path = [FileManager fileCachesPath:@"MyServerInfo.plist"];
    NSError *error = nil;
    return [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
}

@end
