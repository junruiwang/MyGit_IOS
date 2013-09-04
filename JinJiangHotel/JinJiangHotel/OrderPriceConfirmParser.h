//
//  OrderPriceConfirmParser.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/10/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "GDataXMLParser.h"
#import "HotelPriceConfirmForm.h"

#define kKeyCode  @"code"
#define kKeyRate  @"rate" 
#define kKeyRateName  @"name"
#define kKeyPriceDetails  @"priceDetails"
#define kKeyDetail  @"detail"
#define kKeyDate  @"date"
#define kKeyRoomPrice  @"roomPrice"
#define kKeyAddtionalCharge  @"addtionalCharge"
#define kKeyTotalPrice  @"totalPrice"
#define kKeyPrepayPrice  @"prepayPrice"
#define kKeyMessage  @"message"
#define kKeyOrderPriceConfirm  @"orderPriceConfirm"


@interface OrderPriceConfirmParser : GDataXMLParser

- (void)priceConfirmRequest:(HotelPriceConfirmForm *)priceConfirmForm;

@end
