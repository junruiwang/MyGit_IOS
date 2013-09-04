//
//  UserDefaultHelper.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 7/18/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultHelper : NSObject

+(void)writeToCache:(NSDictionary *) dict key:(NSString *) name;

+(NSMutableDictionary *)readFromCache:(NSString *) key;

+(BOOL)isExistCache:(NSString *) key;

@end
