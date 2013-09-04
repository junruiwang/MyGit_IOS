//
//  CreateOrderParser.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/6/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "GDataXMLParser.h"

@class HotelBookForm;

#define kKeyCode  @"code"
#define kKeyMessage  @"message"
#define kKeyOrderNo  @"orderNo"
#define kKeyOrderId  @"orderId"
#define kKeyStatus @"orderStatus"
#define kKeySuccess @"success"
#define kKeyHotelBookResult @"bookResult"
#define kKeyIsMember @"isMember"
#define kKeyMemberInfo @"memberInfo"
#define kKeyUserId @"userId"
#define kKeyFullName @"fullName"
#define kKeyPhone @"phone"
#define kKeyCardNo @"cardNo"

@interface CreateOrderParser : GDataXMLParser

-(void)bookRequest:(HotelBookForm *) hotelBookForm;

@end
