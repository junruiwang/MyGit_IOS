//
//  RenewOrderPayParser.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 7/29/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "GDataXMLParser.h"

#define kKeyCode  @"code"
#define kKeyMessage  @"message"
#define kKeyAmount @"amount"
#define kKeyOrderNo @"orderNo"
#define kKeyBgUrl @"bgUrl"


@interface RenewOrderPriceParser : GDataXMLParser

-(void)getOrderPayInfo:(NSString *) orderNo;

@end
