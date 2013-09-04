//
//  RenewCardParser.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 7/29/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "GDataXMLParser.h"

#import "GDataXMLNode.h"

#define kKeyCode  @"code"
#define kKeyMessage  @"message"
#define kKeyStatus @"status"
#define kKeyOrderNo @"orderNo"


@interface RenewCardParser : GDataXMLParser

-(void)createOrder:(NSString *) cardNo;

@end
