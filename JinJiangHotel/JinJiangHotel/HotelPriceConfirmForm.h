//
//  HotelPriceConfirmForm.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/10/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJHotel.h"

@interface HotelPriceConfirmForm : NSObject

@property (nonatomic, assign) NSInteger hotelId;
@property (nonatomic, copy) NSString* imageUrl;
@property (nonatomic, copy) NSString *hotelCode;
@property (nonatomic, assign) JJHotelOrigin origin;
@property (nonatomic, copy) NSString *rateCode;
@property (nonatomic, copy) NSString *cardType;
@property (nonatomic, assign) NSInteger planId;
@property (nonatomic, copy) NSString *hotelName;
@property (nonatomic, assign) NSInteger roomCount;
@property (nonatomic, copy) NSString *checkInDate;
@property (nonatomic, copy) NSString *checkOutDate;
@property (nonatomic, assign) NSInteger numAdult;
@property (nonatomic, copy) NSString *latestArrivalTime;
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *hotelBrand;
@property (nonatomic, strong) NSString *hotelAddress;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


@end
