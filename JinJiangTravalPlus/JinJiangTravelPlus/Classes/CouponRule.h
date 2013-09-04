//
//  Coupon.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 1/8/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponRule : NSObject

@property (nonatomic, copy) NSString *ruleId;
@property (nonatomic, copy) NSString *couponRuleName;
@property (nonatomic, assign) int couponAmount;
@property (nonatomic, assign) int couponMaxNum;
@property (nonatomic, strong) NSMutableArray *codeList;


@end
