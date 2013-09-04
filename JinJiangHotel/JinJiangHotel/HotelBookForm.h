//
//  HotelBookForm.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/6/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderPriceConfirm.h"

@interface HotelBookForm : NSObject

@property (nonatomic, assign) NSInteger hotelId;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, assign) NSInteger planId;
@property (nonatomic, copy) NSString *hotelName;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, assign) NSInteger roomCount;
@property (nonatomic, assign) NSInteger numAdult;
@property (nonatomic, strong) NSString *checkInDate;
@property (nonatomic, strong) NSString *checkOutDate;
@property (nonatomic, copy) NSString *orderSource;
@property (nonatomic, copy) NSString *checkInPersonName;
@property (nonatomic, copy) NSString *contactPersonName;
@property (nonatomic, copy) NSString *contactPersonMobile;
@property (nonatomic, copy) NSString *latestArrivalTime;
@property (nonatomic, copy) NSString *bookingModule;
@property (nonatomic, copy) NSString *nightNums;
@property (nonatomic, copy) NSString *totalAmount;
@property (nonatomic, copy) NSString *payAmount;
@property (nonatomic, copy) NSString *holdTime;
@property (nonatomic, copy) NSString *tempMemberFlag;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, copy) NSString *couponCodes;
@property (nonatomic, copy) NSString *contactPersonEmail;

@property (nonatomic, copy) NSString *orderStatus;

@property (nonatomic, copy) NSString *specialNeeds;

@property (nonatomic, strong) OrderPriceConfirm *orderPriceConfirm;

-(BOOL)verify;

@end
