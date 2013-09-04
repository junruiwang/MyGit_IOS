//
//  PaymentType.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 3/14/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    YILIANPAY = 0,
    ALIPAY_WAP,
    ALIPAY_APP
} PAYMENT_BUSINESS;

@interface PaymentType : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) PAYMENT_BUSINESS paymentBusiness;

@property (nonatomic,strong) UIButton *paymentSelectButton;

+(id)initPaymentType:(NSString *) name paymentBusiness:(PAYMENT_BUSINESS)paymentBusiness;

@end
