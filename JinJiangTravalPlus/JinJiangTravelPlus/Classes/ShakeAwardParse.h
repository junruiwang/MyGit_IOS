//
// Created by 胡 桂祁 on 5/31/13.
// Copyright (c) 2013 JinJiang. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "GDataXMLParser.h"

#define kKeyCode  @"code"
#define kKeyStatus  @"status"
#define kKeyAward  @"awardDesc"
#define kKeyActiveStatus  @"activeStatus"
#define kKeyEnabled  @"enabled"
#define kKeyMessage  @"message"
#define kKeyPrizeRecordId @"prizeRecordId"
#define kKeyAwardType @"awardType"
#define kKeyCarnivalActivityCode @"MOBILE_CARNIVAL"


@interface ShakeAwardParse : GDataXMLParser

- (void)shakeAward:(NSString*) dayLotteryNum withActivityCode:(NSString *)activity;

@end