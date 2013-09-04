//
//  PayerVerifyParser.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/28/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "GDataXMLParser.h"
#import "PayerVerifyForm.h"

#define kKeyCode  @"code"
#define kKeyMessage @"message"
#define kKeyResult  @"result"
#define kKeySysTrackNo @"sysTrackNo"

@interface PayerVerifyParser : GDataXMLParser

- (void)verifyRequest:(PayerVerifyForm *) payerVerifyForm;
- (void)loadPaymentAmountRequest;
- (void)paymentRequest;

@end
