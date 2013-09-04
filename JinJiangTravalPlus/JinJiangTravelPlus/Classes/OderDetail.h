//
//  OderDetail.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-27.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelOrder.h"

@interface OderDetail : NSObject

@property(nonatomic, strong)NSString* orderNo;
@property(nonatomic, strong)NSString* entryDateTime;

@property(nonatomic, strong)NSString* hotelNm;
@property(nonatomic, strong)NSString* hotelId;
@property(nonatomic, strong)NSString* cityNm;
@property(nonatomic, strong)NSString* cityID;
@property(nonatomic, strong)NSString* roomCode;
@property(nonatomic, strong)NSString* roomName;
@property(nonatomic, strong)NSString* rateName;
@property(nonatomic, strong)NSString* rateCode;

@property(nonatomic, strong)NSString* guestName;
@property(nonatomic, strong)NSString* contactPersonName;
@property(nonatomic, strong)NSString* contactPersonMobile;
@property(nonatomic, strong)NSMutableArray* guests;

@property(nonatomic, strong)NSString* checkin;
@property(nonatomic, strong)NSString* checkOut;

@property(nonatomic, strong)NSString* cancelPolicyDesc;
@property(nonatomic, strong)NSString* guaranteePolicyDesc;

@property(nonatomic)OrderStatus status;
@property(nonatomic, strong)NSString* managementStatus;

@property(nonatomic)unsigned int    rooms;
@property(nonatomic)unsigned int    hotelIdInt;
@property(nonatomic)float   price;
@property(nonatomic)float   paymentAmount;
@property(nonatomic)float   couponAmount;
@property(nonatomic)float   prepaidAmount;

@end
