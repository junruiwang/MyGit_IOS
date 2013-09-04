//
//  OderDetailParser.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-27.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "OderDetailParser.h"
#import "GDataXMLNode.h"
#import "HotelOrder.h"
#import "OrderDetail.h"

@implementation OderDetailParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString])
    {
        NSError* error;
        NSString* hotelNm; NSString* hotelId; NSString* cityID; NSString* cityNm;
        NSString* roomCode; NSString* roomName; NSString* rateCode; NSString* rateName;
        NSString* guestName; NSString* contactPersonName; NSString* contactPersonMobile;
        NSString* guaranteePolicyDesc; NSString* cancelPolicyDesc;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement* rootElement = [document rootElement];
        
        GDataXMLElement* hotelOrderElement = [rootElement firstElementForName:@"hotelOrder"];
        NSString* orderNo       = [[hotelOrderElement firstElementForName:@"orderNo"]         stringValue];
        NSString* entryDateTime = [[hotelOrderElement firstElementForName:@"entryDateTime"]   stringValue];
        {
            GDataXMLElement* hotelElement = [hotelOrderElement firstElementForName:@"hotel"];
            hotelNm = [[hotelElement firstElementForName:@"name"]  stringValue];
            hotelId = [[hotelElement attributeForName:@"id"]       stringValue];
            {
                GDataXMLElement* cityElement = [hotelElement firstElementForName:@"city"];
                cityNm  = [[cityElement firstElementForName:@"name"]  stringValue];
                cityID  = [[cityElement attributeForName:@"id"]       stringValue];
            }
        }
        
        {
            GDataXMLElement* roomElement = [hotelOrderElement firstElementForName:@"room"];
            roomName = [[roomElement firstElementForName:@"name"]   stringValue];
            roomCode = [[roomElement attributeForName:@"code"]      stringValue];
        }
        {
            GDataXMLElement* rateElement = [hotelOrderElement firstElementForName:@"rate"];
            rateName = [[rateElement firstElementForName:@"name"]   stringValue];
            rateCode = [[rateElement attributeForName:@"code"]      stringValue];
        }
        {
            cancelPolicyDesc = [[hotelOrderElement firstElementForName:@"cancelPolicyDesc"]     stringValue];
            guaranteePolicyDesc = [[hotelOrderElement attributeForName:@"guaranteePolicyDesc"]  stringValue];
        }
        const long hotel_id = [hotelId longLongValue];
        const float price = [[[hotelOrderElement firstElementForName:@"price"] stringValue] floatValue];
        const float paymentAmount = [[[hotelOrderElement firstElementForName:@"paymentAmount"] stringValue] floatValue];
        const float couponAmount  = [[[hotelOrderElement firstElementForName:@"couponAmount"]  stringValue] floatValue];
        const float prepaidAmount = [[[hotelOrderElement firstElementForName:@"prepaidAmount"] stringValue] floatValue];

        NSString* checkin  = [[hotelOrderElement firstElementForName:@"checkIn"]  stringValue];
        NSString* checkout = [[hotelOrderElement firstElementForName:@"checkOut"] stringValue];
        const unsigned int rooms = [[[hotelOrderElement firstElementForName:@"rooms"] stringValue] intValue];

        {
            GDataXMLElement* guestElement = [hotelOrderElement firstElementForName:@"guest"];
            guestName = [[guestElement firstElementForName:@"name"]   stringValue];
        }
        {
            GDataXMLElement* contactPersonElement = [hotelOrderElement firstElementForName:@"contactPerson"];
            contactPersonName   = [[contactPersonElement firstElementForName:@"name"]   stringValue];
            contactPersonMobile = [[contactPersonElement firstElementForName:@"mobile"] stringValue];
        }
        NSString* status = [[hotelOrderElement firstElementForName:@"status"]  stringValue];
        NSString* managementStatusStr = [[hotelOrderElement firstElementForName:@"managementStatus"]  stringValue];

        
        NSArray* guestArray = [[hotelOrderElement firstElementForName:@"guest"] elementsForName:@"name"];
        NSMutableArray *guestNames = [NSMutableArray array];
        for (GDataXMLElement* guestNameElement in guestArray)
        {
            [guestNames addObject:[guestNameElement stringValue]];
        }

        
        OrderDetail* order = [[OrderDetail alloc] init];

        if ([status isEqualToString:@"CONFIRM"]) {
            [order setStatus:CONFIRM];
        } else if ([status isEqualToString:@"CANCEL"]) {
            [order setStatus:CANCEL];
        } else if ([status isEqualToString:@"FAIL"]) {
            [order setStatus:FAIL];
        } else if ([status isEqualToString:@"UNPAY"]) {
            [order setStatus:UNPAY];
        } else if ([status isEqualToString:@"PAY_SUCCESS"]) {
            [order setStatus:PAY_SUCCESS];
        } else if ([status isEqualToString:@"PAY_FAILURE"]) {
            [order setStatus:PAY_FAILURE];
        } else if ([status isEqualToString:@"REFUND_ALREADY"]) {
            [order setStatus:REFUND_ALREADY];
        } else if ([status isEqualToString:@"REFUND_SUCCESS"]) {
            [order setStatus:REFUND_SUCCESS];
        }
        [order setGuests:guestNames];
        [order setCheckin:checkin];[order setCheckOut:checkout];
        [order setManagementStatus:managementStatusStr];
        [order setOrderNo:orderNo];[order setEntryDateTime:entryDateTime];
        [order setPaymentAmount:paymentAmount];[order setPrepaidAmount:prepaidAmount];
        [order setPrice:price]; [order setCouponAmount:couponAmount];
        [order setGuestName:guestName];[order setContactPersonMobile:contactPersonMobile];
        [order setContactPersonName:contactPersonName];
        [order setHotelId:hotelId];[order setHotelIdInt:hotel_id];[order setHotelNm:hotelNm];
        [order setRoomCode:roomCode];[order setRoomName:roomName];[order setRooms:rooms];
        [order setCityID:cityID];[order setCityNm:cityNm];
        [order setRateCode:rateCode];[order setRateName:rateName];
        [order setCancelPolicyDesc:cancelPolicyDesc];
        [order setGuaranteePolicyDesc:guaranteePolicyDesc];

        NSDictionary* data = @{@"order":order}; NSLog(@"data = %@", [data description]);

        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {   [self.delegate parser:self DidParsedData:data]; }
    }
    return YES;
}

@end
