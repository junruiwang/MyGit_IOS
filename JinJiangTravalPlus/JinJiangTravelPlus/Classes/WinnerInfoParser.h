//
//  WinnerInfoParser.h
//  JinJiangTravelPlus
//
//  Created by Rong Hao on 13-8-7.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "GDataXMLNode.h"
#import "GDataXMLParser.h"

@interface WinnerInfoParser : GDataXMLParser

- (void)sendWinnerName:(NSString*)winnerName phoneNumber:(NSString *)phoneNumber address:(NSString *)address prizeRecordId:(NSString *)prizeRecordId;
@end
