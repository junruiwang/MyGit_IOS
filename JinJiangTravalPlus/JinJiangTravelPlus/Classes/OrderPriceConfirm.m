//
//  OrderPriceConfirm.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/10/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "OrderPriceConfirm.h"

@implementation OrderPriceConfirm

- (id)initWithRateCode:(NSString *)rateCode rateName:(NSString *)rateName date:(NSString *)date roomPrice:(NSString *)roomPrice addtionalCharge:(NSString *)addtionalCharge totalPrice:(NSString *)totalPrice prepayPrice:(NSString *)prepayPrice {
    self = [super init];
    if (self) {
        _rateCode = rateCode;
        _rateName = rateName;
        _date = date;
        _roomPrice = roomPrice;
        _addtionalCharge = addtionalCharge;
        _totalPrice = totalPrice;
        _prepayPrice = prepayPrice;
    }

    return self;
}

+ (id)objectWithRateCode:(NSString *)rateCode rateName:(NSString *)rateName date:(NSString *)date roomPrice:(NSString *)roomPrice addtionalCharge:(NSString *)addtionalCharge totalPrice:(NSString *)totalPrice prepayPrice:(NSString *)prepayPrice {
    return [[OrderPriceConfirm alloc] initWithRateCode:rateCode rateName:rateName date:date roomPrice:roomPrice addtionalCharge:addtionalCharge totalPrice:totalPrice prepayPrice:prepayPrice];
}


@end
