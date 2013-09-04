//
//  UnionPaymentForm.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/28/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentType.h"

@interface UnionPaymentForm : NSObject

@property (nonatomic,copy) NSString *cardNo;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *businessPart;
@property (nonatomic,copy) NSString *amount;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,copy) NSString *hotelName;
@property (nonatomic,copy) NSString *trackNo;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *buyerIpip;
@property (nonatomic,copy) NSString *beneficiary;
@property (nonatomic,copy) NSString *beneficiaryPhone;
@property (nonatomic,copy) NSString *openingBankName;
@property (nonatomic,copy) NSString *openingBankIdentityNo;
@property (nonatomic,copy) NSString *openingBankPhone;
@property (nonatomic,copy) NSString *openingBankCityName;
@property (nonatomic,copy) NSString *identifyType;
//IDENTIFICATIONCARD

@property (nonatomic,assign) BOOL isNewOrGrayPanel;
@property (nonatomic, copy) NSString *orderAmount;
@property (nonatomic, copy) NSString *contactPhoneNumber;

@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *orderId;

@property (nonatomic,assign) PAYMENT_BUSINESS paymentBusiness;

@end
