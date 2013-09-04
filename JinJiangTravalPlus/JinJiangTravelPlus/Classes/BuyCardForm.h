//
//  BuyCardForm.h
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-5-31.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValidateInputUtil.h"

@interface BuyCardForm : NSObject

@property (nonatomic, strong) NSString *provinceId;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *districtId;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *mcMemberCode;
@property (nonatomic, strong) NSString *certificateType;
@property (nonatomic, strong) NSString *certificateNo;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *memberType;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *postCode;

- (BOOL)checkValueNotNull;

@end
