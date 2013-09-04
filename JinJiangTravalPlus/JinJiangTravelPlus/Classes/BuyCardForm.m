//
//  BuyCardForm.m
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-5-31.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "BuyCardForm.h"

@implementation BuyCardForm

- (BOOL)checkValueNotNull
{
    return [ValidateInputUtil isNotEmpty:self.provinceId fieldCName:@"省份"] &&
    [ValidateInputUtil isNotEmpty:self.cityId fieldCName:@"省份"] &&
    [ValidateInputUtil isNotEmpty:self.districtId fieldCName:@"省份"] &&
    [ValidateInputUtil isNotEmpty:self.address fieldCName:@"地址"] &&
    [ValidateInputUtil isNotEmpty:self.certificateType fieldCName:@"证件类型"] &&
    [ValidateInputUtil isNotEmpty:self.userName fieldCName:@"姓名"] &&
    [ValidateInputUtil isNotEmpty:self.postCode fieldCName:@"邮编"] &&
    ([@"ID" isEqualToString:self.certificateType] ? [ValidateInputUtil isIdentifyNumber:self.certificateNo] : YES);
}

@end
