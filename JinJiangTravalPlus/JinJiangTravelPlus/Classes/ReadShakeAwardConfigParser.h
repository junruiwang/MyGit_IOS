//
//  ReadShakeAwardConfParser.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 5/30/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "GDataXMLParser.h"

#define kKeyStatus  @"status"
#define kKeyEnabled  @"enabled"
#define kKeyDateStr  @"dateStr"

@interface ReadShakeAwardConfigParser : GDataXMLParser

- (void)getShakeAwardConfig:(NSString *)dayLotteryNum;

@end
