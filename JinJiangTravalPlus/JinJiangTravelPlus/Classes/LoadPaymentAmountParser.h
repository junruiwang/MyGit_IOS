//
//  LoadPaymentAmountParser.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 1/4/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "GDataXMLParser.h"

#define kKeyCode  @"code"
#define kKeyMessage @"message"
#define kKeyOrderNo  @"orderNo"
#define kKeyPaymentAmount @"paymentAmount"

@interface LoadPaymentAmountParser : GDataXMLParser


-(void)loadPaymentAmount:(NSString *)orderNo;

@end
