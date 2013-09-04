//
//  PassbookForm.h
//  JinJiangTravelPlus
//
//  Created by huguiqi on 13-1-31.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderPassbookForm : NSObject

@property(nonatomic,copy) NSString *orderNo;
@property(nonatomic,copy) NSString *hotelName;
@property(nonatomic,copy) NSString *hotelBrand;
@property(nonatomic,copy) NSString *nightsNum;
@property(nonatomic,copy) NSString *checkInDate;
@property(nonatomic,copy) NSString *checkOutDate;
@property(nonatomic,copy) NSString *checkInPerson;
@property(nonatomic,copy) NSString *roomType;
@property(nonatomic,copy) NSString *latitude;
@property(nonatomic,copy) NSString *longitude;
@property(nonatomic,copy) NSString *hotelAddress;
@property(nonatomic,copy) NSString *orderAmount;


@end
