//
//  OrderPriceConfirm.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/10/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayType.h"


@interface OrderPriceConfirm : NSObject

@property (nonatomic,copy) NSString *rateCode;
@property (nonatomic,copy) NSString *rateName;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *roomPrice;
@property (nonatomic,copy) NSString *addtionalCharge;
@property (nonatomic,copy) NSString *totalPrice;
@property (nonatomic,copy) NSString *prepayPrice;
@property (nonatomic, strong) NSMutableArray *payTypeList;
@property (nonatomic, strong) NSMutableArray *dayPriceDetailList;


- (id)initWithRateCode:(NSString *)rateCode rateName:(NSString *)rateName date:(NSString *)date roomPrice:(NSString *)roomPrice addtionalCharge:(NSString *)addtionalCharge totalPrice:(NSString *)totalPrice prepayPrice:(NSString *)prepayPrice;

+ (id)objectWithRateCode:(NSString *)rateCode rateName:(NSString *)rateName date:(NSString *)date roomPrice:(NSString *)roomPrice addtionalCharge:(NSString *)addtionalCharge totalPrice:(NSString *)totalPrice prepayPrice:(NSString *)prepayPrice;

@end
