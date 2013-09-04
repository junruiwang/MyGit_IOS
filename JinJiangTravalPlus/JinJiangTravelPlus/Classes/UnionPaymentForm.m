//
//  UnionPaymentForm.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/28/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "UnionPaymentForm.h"

@implementation UnionPaymentForm

@synthesize cardNo;
@synthesize phone;
@synthesize businessPart;
@synthesize amount;
@synthesize remark;
@synthesize orderNo;
@synthesize hotelName;
@synthesize trackNo;
@synthesize userId;
@synthesize userName;
@synthesize buyerIpip;
@synthesize beneficiary;
@synthesize beneficiaryPhone;

@synthesize openingBankName;
@synthesize openingBankIdentityNo;
@synthesize openingBankPhone;
@synthesize openingBankCityName;
@synthesize identifyType;

@synthesize isNewOrGrayPanel;

@synthesize orderAmount;

@synthesize contactPhoneNumber;

@synthesize source;

-(id)init
{
    self = [super init];
    self.businessPart = @"HOTEL";
    self.identifyType = @"IDENTIFICATIONCARD";
    return self;
}

@end
