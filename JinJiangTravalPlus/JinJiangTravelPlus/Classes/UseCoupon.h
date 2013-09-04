//
//  Coupon.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 1/8/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UseCoupon : NSObject

@property (nonatomic,copy) NSString *couponName;
@property (nonatomic,copy) NSString *couponDesc;
@property (nonatomic) NSUInteger couponAmount;
@property (nonatomic) NSUInteger totalAmount;
@property (nonatomic) NSInteger useCouponNum;
@property (nonatomic, copy) NSString *codeList;
@property (nonatomic) NSUInteger couponIndex;

@end
