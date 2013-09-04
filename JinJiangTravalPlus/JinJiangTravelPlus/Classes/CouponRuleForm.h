//
//  CouponRuleForm.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 1/11/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponRuleForm : NSObject

@property (nonatomic) unsigned int orderAmount;
@property (nonatomic) unsigned int payAmount;
@property (nonatomic) unsigned int numRoomNights;
@property (nonatomic,copy) NSString* dateCheckIn;
@property (nonatomic,copy) NSString* bookModule;

@end
