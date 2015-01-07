//
//  CodeUtil.h
//  IntelligentHome
//
//  Created by jerry on 14-1-12.
//  Copyright (c) 2014年 jerry.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodeUtil : NSObject

+ (NSString *)hexStringFromString:(NSString *)string;

+ (NSString *)stringFromHexString:(NSString *)hexString;

@end
