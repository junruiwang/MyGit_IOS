//
//  OrderListParser.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-26.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "OrderListParser.h"
#import "GDataXMLNode.h"
#import "HotelOrder.h"

@implementation OrderListParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString])
    {
        NSDateFormatter *maxFormatter = [[NSDateFormatter alloc] init] ;
        [maxFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* minDate = [maxFormatter dateFromString:@"2020-12-31"];
        NSString* minCheckIn =  [maxFormatter stringFromDate:minDate];
        NSString* minCheckOut = [maxFormatter stringFromDate:minDate];
        NSString* minHotel = @"北京";

        NSError* error; unsigned int unpaied = 0;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement* rootElement = [document rootElement];

        GDataXMLElement* hotelOrdersDataElement = [rootElement elementsForName:@"hotelOrders"][0];
        NSArray* hotelOrderElementArray = [hotelOrdersDataElement elementsForName:@"hotelOrder"];
        NSMutableArray* orderList = [[NSMutableArray alloc] initWithCapacity:hotelOrderElementArray.count];
        NSMutableArray* showArray = [[NSMutableArray alloc] initWithCapacity:hotelOrderElementArray.count];

        for (GDataXMLElement* hotelOrderElement in hotelOrderElementArray)
        {
            GDataXMLElement* hotelElement = [hotelOrderElement firstElementForName:@"hotel"];
            NSString* orderNo  = [[hotelOrderElement firstElementForName:@"orderNo"]  stringValue];
            NSString* orderId  = [[hotelOrderElement firstElementForName:@"orderId"]  stringValue];
            NSString* checkin  = [[hotelOrderElement firstElementForName:@"checkin"]  stringValue];
            NSString* checkout = [[hotelOrderElement firstElementForName:@"checkout"] stringValue];
            NSString* hotelNm  = [[hotelElement      firstElementForName:@"name"]     stringValue];
            NSString* hotelId  = [[hotelElement      attributeForName:@"id"]          stringValue];
            const long hotel_id = [hotelId longLongValue];
            const float price = [[[hotelOrderElement firstElementForName:@"price"] stringValue] floatValue];
            const float paymentAmount = [[[hotelOrderElement firstElementForName:@"paymentAmount"] stringValue] floatValue];
            const float couponAmount  = [[[hotelOrderElement firstElementForName:@"couponAmount"]  stringValue] floatValue];
            NSString* status  = [[hotelOrderElement firstElementForName:@"status"]  stringValue];

            HotelOrder* order = [[HotelOrder alloc] init];
            [order setCheckin:checkin];[order setCheckout:checkout];
            [order setOrderId:orderId];[order setOrderNo:orderNo];
            [order setHotelName:hotelNm];[order setHotelId:hotel_id];
            [order setPaymentAmount:paymentAmount];[order setPrice:price];
            [order setCouponAmount:couponAmount];

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

            [orderList addObject:order];

            if (order.status == CONFIRM || order.status == UNPAY ||
                order.status == PAY_SUCCESS || order.status == PAY_FAILURE)
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate* checkout = [formatter dateFromString:order.checkout];
                NSDate* checkin  = [formatter dateFromString:order.checkin];
                NSDate* today   = [NSDate date];
                
                if ([checkout compare:today] == NSOrderedDescending ||
                    [checkout compare:today] == NSOrderedSame)
                {
                    [showArray addObject:order];//NSLog(@"checkin = %@", [formatter stringFromDate:checkout]);

                    if (order.status == UNPAY || order.status == PAY_FAILURE)
                    {   unpaied = unpaied + 1;  }

                    if ([checkin compare:minDate] == NSOrderedAscending)
                    {   minDate = checkin;  minCheckOut = order.checkout;   minCheckIn = order.checkin; minHotel = order.hotelName;}
                }
            }
        }

        NSDictionary* data = @{@"total":@(hotelOrderElementArray.count), @"orderList":orderList, @"showArray":showArray,
            @"unpaied":@(unpaied), @"minCheckIn":minCheckIn, @"minCheckOut":minCheckOut, @"minHotel":minHotel};
        
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {   [self.delegate parser:self DidParsedData:data]; }
    }
    return YES;
}

@end
