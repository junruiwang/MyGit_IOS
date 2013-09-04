//
//  HotelOrder.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-26.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _OrderStatus
{
    CONFIRM = 101,
    CANCEL,
    FAIL,
    UNPAY,
    PAY_SUCCESS,
    PAY_FAILURE,
    REFUND_ALREADY,
    REFUND_SUCCESS,

}   OrderStatus ;

@interface HotelOrder : NSObject

@property(nonatomic, strong)NSString* orderNo;
@property(nonatomic, strong)NSString* orderId;
@property(nonatomic, strong)NSString* hotelName;
@property(nonatomic)long    hotelId;
@property(nonatomic)float   price;
@property(nonatomic)float   paymentAmount;
@property(nonatomic)float   couponAmount;
@property(nonatomic, strong)NSString* checkin;
@property(nonatomic, strong)NSString* checkout;
@property(nonatomic)OrderStatus status;

@end
