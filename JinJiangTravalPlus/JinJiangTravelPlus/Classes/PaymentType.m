//
//  PaymentType.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 3/14/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "PaymentType.h"

@implementation PaymentType

+(id)initPaymentType:(NSString *)name paymentBusiness:(PAYMENT_BUSINESS )paymentBusiness
{
    PaymentType *paymentType = nil;
    if(self){
        paymentType = [[super alloc] init];
        paymentType.name = name;
        paymentType.paymentBusiness= paymentBusiness;
        CGRect payBtnFrame = CGRectMake(275, 10, 20, 20);
        paymentType.paymentSelectButton = [[UIButton alloc] initWithFrame:payBtnFrame];
        paymentType.paymentSelectButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"arrow2.png"]];
    }
    return paymentType;
    
}

@end
