//
//  OrderCoupon.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 1/8/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderCoupon : NSObject

@property (nonatomic) NSUInteger couponAmount;
@property (nonatomic,copy) NSString *endDate;
@property (nonatomic) NSUInteger maxUseSize;
@property (nonatomic) NSUInteger canUseCoupon;



@end
