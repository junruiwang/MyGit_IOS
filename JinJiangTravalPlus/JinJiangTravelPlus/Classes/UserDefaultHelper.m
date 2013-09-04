//
//  UserDefaultHelper.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 7/18/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "UserDefaultHelper.h"

@implementation UserDefaultHelper

+(void)writeToCache:(NSDictionary *) dict key:(NSString *) name
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dict forKey:name];
    [defaults synchronize];
}

+(NSMutableDictionary *)readFromCache:(NSString *) key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *readDict = [[defaults objectForKey:key] mutableCopy];
    return readDict;
}

+(BOOL)isExistCache:(NSString *) key
{
    NSMutableDictionary *readDict = [self readFromCache:key];
    if (readDict && [readDict count]>0) {
        return YES;
    }
    return NO;
}


@end
