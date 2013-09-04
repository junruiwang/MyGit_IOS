//
//  JJCoupon.h
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-22.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    UNUSED = 1,
    USED = 2,
    OBSOLETE = 3,
    EXPIRED = 4,
    LOCKED = 6,
}   JJCouponStatus;

@interface JJCoupon : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *usePlate;
@property (nonatomic) int amount;
@property (nonatomic) JJCouponStatus status;

+ (JJCouponStatus)couponStatusFromName:(NSString *)statusName;

@end
