//
//  NSString+Categories.h
//  JinJiangTravalPlus
//
//  Created by Leon on 10/29/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Categories)

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (BOOL)isPureInt;
- (BOOL)isEmail;
- (BOOL)isPhoneNumber;
- (BOOL)isCardNumber;
- (BOOL)isIdentifyNumber;
- (BOOL)isBlank;
- (NSString *)removeSpace;
- (NSString *)nilStringFlagJudge; // return nil if string equal to @"nil"
- (NSString*)sortedQueryString;
- (NSString*)trim;

@end
