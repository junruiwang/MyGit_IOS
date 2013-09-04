//
//  ValidateInputUtil.h
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-21.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Categories.h"

@interface ValidateInputUtil : NSObject

+ (BOOL)isNotEmpty:(NSString *)text fieldCName:(NSString *)cName;
+ (BOOL)isEffectivePhone:(NSString *)text;
+ (BOOL)isEffectiveEmail:(NSString *)text;
+ (BOOL)isEffectivePassword:(NSString *)text;
+ (BOOL)isCardNumber :(NSString *) text;
+ (BOOL)isPureInt:(NSString *) text;
+ (BOOL)isIdentifyNumber :(NSString *) text;
+ (BOOL)isEffectGuestNames:(NSString *)text guestCount:(NSInteger)guestCount;
@end
