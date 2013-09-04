//
//  CreateOrderParser.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/6/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "CreateOrderParser.h"
#import "HotelBookForm.h"
#import "ParameterManager.h"
#import "GDataXMLNode.h"
#import "HotelBookResult.h"
#import "Constants.h"

@implementation CreateOrderParser

#define NSTimeIntervalSince1970  978307200.0

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString])
    {
        NSError *error;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
        GDataXMLNode *codeNode = [rootElement attributeForName:kKeyCode];
        NSString *code = [codeNode stringValue];
        NSString *success = [[rootElement elementsForName:kKeySuccess][0] stringValue];
        NSString *message = [[rootElement elementsForName:kKeyMessage][0] stringValue];
        NSString *orderStatus = [[rootElement elementsForName:kKeyStatus][0] stringValue];
        NSString *orderNo = [[rootElement elementsForName:kKeyOrderNo][0] stringValue];
        NSString *orderId = [[rootElement elementsForName:kKeyOrderId][0] stringValue];

        if ([@"0" isEqualToString:code] && success && [@"T" isEqualToString:success])
        {
            HotelBookResult *bookResult = [HotelBookResult objectWithCode:code successFlag:success
                                                                  message:message orderStatus:orderStatus
                                                                  orderNo:orderNo orderId:orderId];
            NSDictionary *data = @{@"bookResult" : bookResult};
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
            {   [self.delegate parser:self DidParsedData:data]; }
        }
        else
        {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:)])
            {   [self.delegate parser:self DidFailedParseWithMsg:message errCode:[code intValue]];  }
            return NO;
        }
    }
    return YES;
}

- (void)bookRequest:(HotelBookForm *)hotelBookForm
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"dateCheckIn" WithValue:hotelBookForm.checkInDate];
    [parameterManager parserStringWithKey:@"dateCheckOut" WithValue:hotelBookForm.checkOutDate];
    [parameterManager parserIntegerWithKey:@"roomCount" WithValue:hotelBookForm.roomCount];
    [parameterManager parserIntegerWithKey:@"planId" WithValue:hotelBookForm.planId];
    [parameterManager parserIntegerWithKey:@"hotelId" WithValue:hotelBookForm.hotelId];
    [parameterManager parserIntegerWithKey:@"numAdult" WithValue:hotelBookForm.numAdult];
    [parameterManager parserStringWithKey:@"contactPersonName" WithValue:hotelBookForm.contactPersonName];
    [parameterManager parserStringWithKey:@"contactPersonMobile" WithValue:hotelBookForm.contactPersonMobile];
    [parameterManager parserStringWithKey:@"contactPersonEmail" WithValue:hotelBookForm.contactPersonEmail];
    [parameterManager parserStringWithKey:@"guestName" WithValue:hotelBookForm.checkInPersonName];
    [parameterManager parserStringWithKey:@"totalPrice" WithValue:hotelBookForm.totalAmount];
    [parameterManager parserStringWithKey:@"payAmount" WithValue:hotelBookForm.payAmount];
    [parameterManager parserStringWithKey:@"arrivalLatestTime" WithValue:hotelBookForm.latestArrivalTime];
    [parameterManager parserStringWithKey:@"orderType" WithValue:hotelBookForm.orderType];
    [parameterManager parserStringWithKey:@"specialNeeds" WithValue:hotelBookForm.specialNeeds];
    [parameterManager parserStringWithKey:@"bookingModule" WithValue:hotelBookForm.bookingModule];
    [parameterManager parserStringWithKey:@"numRoomNights" WithValue:hotelBookForm.nightNums];
    [parameterManager parserStringWithKey:@"couponCodes" WithValue:hotelBookForm.couponCodes];

    [parameterManager parserStringWithKey:@"flag" WithValue:hotelBookForm.tempMemberFlag];
    self.serverAddress = kHotelOrderPlaceURL;
    
    self.requestString = [parameterManager serialization];
    [self start];
}

@end
