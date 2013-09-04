//
//  CouponRuleListParser.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 1/11/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "GDataXMLParser.h"
#import "CouponRuleForm.h"

#define kKeyCode  @"code"
#define kKeyMessage  @"message"
#define kKeyCoupons @"coupons"
#define kKeyCoupon  @"coupon"
#define kKeyRuleId @"ruleId"
#define kKeyCouponRuleName @"couponRuleName"
#define kKeyCouponAmount @"couponAmount"
#define kKeyCouponMaxNum @"couponMaxNum"
#define kKeyCouponCode   @"couponCode"
#define kKeyCodeList     @"codeList"


@interface CouponRuleListParser : GDataXMLParser

-(void)couponRuleListRequest:(CouponRuleForm *) couponRuleForm;


@end

