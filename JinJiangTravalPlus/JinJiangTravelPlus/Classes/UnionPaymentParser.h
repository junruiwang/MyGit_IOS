//
//  UnionPaymentParser.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/28/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "GDataXMLParser.h"
#import "UnionPaymentForm.h"

#define kKeyCode  @"code"
#define kKeyMessage @"message"
#define kKeyResult  @"result"

@interface UnionPaymentParser : GDataXMLParser

-(void)paymentRequest:(UnionPaymentForm *) paymentForm;

@property(nonatomic, strong) NSString *ipAddress;

@end
