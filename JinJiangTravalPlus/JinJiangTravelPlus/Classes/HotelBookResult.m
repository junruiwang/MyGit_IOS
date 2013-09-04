//
//  HotelBookReslut.m
//  JinJiangTravelPlus
//
//  Created by huguiqi on 12-12-7.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "HotelBookResult.h"

@implementation HotelBookResult

- (id)initWithCode:(NSString *)code successFlag:(NSString *)successFlag message:(NSString *)message orderStatus:(NSString *)orderStatus orderNo:(NSString *)orderNo orderId:(NSString *)orderId{
    self = [super init];
    if (self) {
        _code = code;
        _successFlag = successFlag;
        _message = message;
        _orderStatus = orderStatus;
        _orderNo = orderNo;
        _orderId = orderId;
    }

    return self;
}

+ (id)objectWithCode:(NSString *)code successFlag:(NSString *)successFlag message:(NSString *)message orderStatus:(NSString *)orderStatus orderNo:(NSString *)orderNo  orderId:(NSString *)orderId{
    return [[HotelBookResult alloc] initWithCode:code successFlag:successFlag message:message orderStatus:orderStatus orderNo:orderNo orderId:orderId];
}


@end
