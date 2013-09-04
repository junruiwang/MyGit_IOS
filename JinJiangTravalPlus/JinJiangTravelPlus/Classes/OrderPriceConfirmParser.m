//
//  OrderPriceConfirmParser.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/10/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "OrderPriceConfirmParser.h"
#import "GDataXMLNode.h"
#import "ParameterManager.h"
#import "OrderPriceConfirm.h"
#import "PayType.h"
#import "Brand.h"
#import "DayPriceDetail.h"

@implementation OrderPriceConfirmParser

- (BOOL)parseXmlString:(NSString *)xmlString {
    if ([super parseXmlString:xmlString]) {
        NSError *error;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
        GDataXMLNode *codeNode = [rootElement attributeForName:kKeyCode];
        NSString *code = [codeNode stringValue];

        if ([@"0" isEqualToString:code]) {
            OrderPriceConfirm *orderPriceConfirm = [self buildOrderPriceConfirm:rootElement];
            NSDictionary *data = @{@"orderPriceConfirm" : orderPriceConfirm};
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
                [self.delegate parser:self DidParsedData:data];
        } else {
            NSString *message = [[rootElement elementsForName:kKeyMessage][0] stringValue];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:)])
                [self.delegate parser:self DidFailedParseWithMsg:message errCode:[code intValue]];
            return NO;
        }
    }
    return YES;
}

- (OrderPriceConfirm *)buildOrderPriceConfirm:(GDataXMLElement *)rootElement {
    GDataXMLElement *rate = [rootElement elementsForName:kKeyRate][0];
    GDataXMLElement *totalPriceElem = [rootElement elementsForName:kKeyTotalPrice][0];
    GDataXMLElement *prepayPriceElem = [rootElement elementsForName:kKeyPrepayPrice][0];
    
    NSString *totalPrice = [totalPriceElem stringValue];
    NSString *prepayPrice = [prepayPriceElem stringValue];
    GDataXMLNode *rateIdNode = [rate attributeForName:@"id"];
    NSString *rateCode = rate && rateIdNode ? [rate stringValue] : @"";

    GDataXMLElement *rateNameElem = rate ?[rate elementsForName:kKeyRateName][0] : nil;
    NSString *rateName = rateNameElem ? [rateNameElem stringValue] : @"";
    GDataXMLElement *priceDetailsElem = [rootElement elementsForName:kKeyPriceDetails][0];
    GDataXMLElement *detailElem = nil;
    GDataXMLElement *dateElem = nil;
    GDataXMLElement *roomPriceElem = nil;
    GDataXMLElement *addtionalChargeElem = nil;
    
    if (priceDetailsElem) {
        detailElem = [priceDetailsElem elementsForName:kKeyDetail][0];
        if (detailElem) {
            dateElem = [detailElem elementsForName:kKeyDate][0];
            roomPriceElem = [detailElem elementsForName:kKeyRoomPrice][0];
            addtionalChargeElem = [detailElem elementsForName:kKeyAddtionalCharge][0];
        }
    }
    //<?xml version="1.0" encoding="UTF-8"?>
    //<data code="0">
    //<rate>
    //<code>SCard</code>
    //<name>积分会员价格码</name>
    //</rate>
    //<payTypes>
    //<payType>
    //<name>PAYMENTING</name>
    //<cnName>现付单</cnName>
    //<amount>100</amount>
    //<totalChargePrice>0.0</totalChargePrice>
    //<description>门店支付</description>
    //<label>门店支付</label>
    //</payType>
    //<payType>
    //<name>GUARANTEE</name>
    //<cnName>担保单</cnName>
    //<amount>100</amount>
    //<totalChargePrice>0.0</totalChargePrice>
    //<description>支付首晚房费，房间保留至次日12:00</description>
    //<label>预付首晚</label>
    //</payType>
    //</payTypes>
    //<dayPriceDetails>
    //<detail>
    //<date>2013-01-10</date>
    //<roomPrice>100</roomPrice>
    //<addtionalCharge>0</addtionalCharge>
    //</detail>
    //</dayPriceDetails>
    //<totalPrice>100</totalPrice>
    //<prepayPrice>0</prepayPrice>
    //</data>
    NSString *date = dateElem ? [dateElem stringValue] : nil;
    NSString *roomPrice = roomPriceElem ? [roomPriceElem stringValue] : nil;
    NSString *addtionalCharge = addtionalChargeElem ? [addtionalChargeElem stringValue] : nil;
    OrderPriceConfirm *orderPriceConfirm = [OrderPriceConfirm objectWithRateCode:rateCode rateName:rateName date:date roomPrice:roomPrice addtionalCharge:addtionalCharge totalPrice:totalPrice prepayPrice:prepayPrice];

    orderPriceConfirm.payTypeList = [[NSMutableArray alloc] initWithCapacity:30];
    GDataXMLElement *payTypeListElement = [rootElement elementsForName:@"payTypes"][0];
    NSArray *payTypeListArray = [payTypeListElement elementsForName:@"payType"];

    for (GDataXMLElement *payTypeElement in payTypeListArray) {
        NSString *name = [[payTypeElement firstElementForName:@"name"] stringValue];
        NSString *cnName = [[payTypeElement firstElementForName:@"cnName"] stringValue];
        NSString *description = [[payTypeElement firstElementForName:@"description"] stringValue];
        NSString *label = [[payTypeElement firstElementForName:@"label"] stringValue];
        NSString *amount = [[payTypeElement firstElementForName:@"amount"] stringValue];
        NSString *totalChargePrice = [[payTypeElement firstElementForName:@"totalChargePrice"] stringValue];
        NSString *cancelPolicyDesc = [[payTypeElement firstElementForName:@"cancelPolicyDesc"] stringValue];
        PayType *payType = [[PayType alloc] initWithPayTypeInfo:name cnName:cnName description:description label:label amount:amount totalChargePrice:totalChargePrice cancelPolicyDesc:cancelPolicyDesc];
        [orderPriceConfirm.payTypeList addObject:payType];
    }

    orderPriceConfirm.dayPriceDetailList = [[NSMutableArray alloc] initWithCapacity:30];
    GDataXMLElement *dayPriceDetailsElement = [rootElement elementsForName:@"dayPriceDetails"][0];
    NSArray *dayPriceDetailArray = [dayPriceDetailsElement elementsForName:@"detail"];

    for (GDataXMLElement *dayPriceDetailElement in dayPriceDetailArray) {
        NSString *date = [[dayPriceDetailElement firstElementForName:@"date"] stringValue];
        NSString *roomPrice = [[dayPriceDetailElement firstElementForName:@"roomPrice"] stringValue];
        NSString *addtionalCharge = [[dayPriceDetailElement firstElementForName:@"addtionalCharge"] stringValue];
        
        DayPriceDetail *dayPriceDetail = [[DayPriceDetail alloc] init];
        dayPriceDetail.date = date;
        dayPriceDetail.roomPrice = roomPrice;
        dayPriceDetail.addtionalCharge = addtionalCharge;
        [orderPriceConfirm.dayPriceDetailList addObject:dayPriceDetail];
    }

    return orderPriceConfirm;
}

- (void)priceConfirmRequest:(HotelPriceConfirmForm *)priceConfirmForm {
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserIntegerWithKey:@"hotelId" WithValue:priceConfirmForm.hotelId];
    [parameterManager parserIntegerWithKey:@"planId" WithValue:priceConfirmForm.planId];
    [parameterManager parserStringWithKey:@"hotelCode" WithValue:priceConfirmForm.hotelCode];
    [parameterManager parserStringWithKey:@"dateCheckIn" WithValue:priceConfirmForm.checkInDate];
    [parameterManager parserStringWithKey:@"dateCheckOut" WithValue:priceConfirmForm.checkOutDate];
    [parameterManager parserIntegerWithKey:@"roomCount" WithValue:priceConfirmForm.roomCount];
    [parameterManager parserStringWithKey:@"rateCode" WithValue:priceConfirmForm.rateCode];
    [parameterManager parserStringWithKey:@"cardType" WithValue:priceConfirmForm.cardType];
    [parameterManager parserIntegerWithKey:@"numAdult" WithValue:priceConfirmForm.numAdult];
    [parameterManager parserIntegerWithKey:@"nights" WithValue:TheAppDelegate.hotelSearchForm.nightNums];
    [parameterManager parserStringWithKey:@"arrivalLatestTime" WithValue:priceConfirmForm.latestArrivalTime];

    self.requestString = [parameterManager serialization];
    self.serverAddress = kHotelPriceConfirmURL;
    [self start];
}
@end
