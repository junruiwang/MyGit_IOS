//
//  HotelListParser.m
//  JinJiangTravalPlus
//
//  Created by Leon on 11/7/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#import "HotelListParser.h"
#import "GDataXMLNode.h"
#import "JJHotel.h"
#import "Constants.h"

@implementation HotelListParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString] )
    {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];

        NSMutableArray *hotelList = [[NSMutableArray alloc] init];
        unsigned int total = 0;
        if ([rootElement elementsForName:@"hotels"].count > 0)
        {
            GDataXMLElement *hotelsElement = [rootElement elementsForName:@"hotels"][0];
            NSArray *hotelElementArray = [hotelsElement elementsForName:@"hotel"];
            total = [[hotelsElement attributeForName:@"total"] intValue];
            for (GDataXMLElement *hotelElement in hotelElementArray)
            {
                const int hotelId = [[hotelElement attributeForName:@"id"] intValue];
                NSString *name = [[hotelElement firstElementForName:@"name"] stringValue];
                NSString *hotelRate = [[hotelElement firstElementForName:@"hotelRate"] stringValue];
                NSString *imageUrl = [[[hotelElement firstElementForName:@"imageUrl"] stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString *address = [[hotelElement firstElementForName:@"address"] stringValue];
                NSString *telphone = [[hotelElement firstElementForName:@"tel"] stringValue];

                float lat = [[hotelElement firstElementForName:@"lat"] floatValue];
                float lng = [[hotelElement firstElementForName:@"lng"] floatValue];
                const int star = [JJHotel starFromName:[[hotelElement firstElementForName:@"star"] stringValue]];
                const int price = [[hotelElement firstElementForName:@"price"] intValue];
                NSString *zone = [[hotelElement firstElementForName:@"zone"] stringValue];
                JJHotelBrand brand = [JJHotel brandFromName:[[hotelElement firstElementForName:@"brand"] stringValue]];
                const BOOL hasCoupon = [[hotelElement firstElementForName:@"hasCoupon"] boolValue];

                JJHotel *hotel = [[JJHotel alloc] init];
                hotel.hotelId = hotelId;
                hotel.name = name;
                hotel.hotelRate = hotelRate;
                hotel.imageUrl = imageUrl;
                hotel.address = address;
                hotel.telphone = telphone;
                hotel.coordinate = CLLocationCoordinate2DMake(lat, lng);
                hotel.star = star;
                hotel.price = price;
                hotel.zone = zone;
                hotel.brand = brand;
                hotel.hasCoupon = hasCoupon;

                const CLLocation *destination = [[CLLocation alloc] initWithLatitude:TheAppDelegate.hotelSearchForm.searchPoint.latitude
                                                                           longitude:TheAppDelegate.hotelSearchForm.searchPoint.longitude];
                CLLocation *hotelPositon = [[CLLocation alloc] initWithLatitude:hotel.coordinate.latitude longitude:hotel.coordinate.longitude];
                hotel.distance = [hotelPositon distanceFromLocation:(const CLLocation *)destination] / 1000;

                [hotelList addObject:hotel];
            }
            
            NSDictionary *data = @{@"total":@(total) ,@"hotelList":hotelList};
            
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
                [self.delegate parser:self DidParsedData:data];
        }
    }
    return YES;
}

@end
