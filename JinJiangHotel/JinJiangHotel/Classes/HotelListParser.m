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
#import "ParameterManager.h"
#import "CloNetworkUtil.h"

#define kHotelPageSize_10 10
#define kHotelPageSize_5 5

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
                NSString *imageUrl = [[[hotelElement firstElementForName:@"bigImageUrl"] stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString *iconUrl = [[[hotelElement firstElementForName:@"imageUrl"] stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
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
                hotel.iconUrl = iconUrl;
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

-(void)getHotelList:(NSInteger)pageIndex  orderName:(NSString *)orderName orderVal:(NSString *)orderVal
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"cityName" WithValue:TheAppDelegate.hotelSearchForm.cityName];
    [parameterManager parserStringWithKey:@"dateCheckIn" WithValue:[TheAppDelegate.hotelSearchForm.checkinDate chineseDescription]];
    [parameterManager parserStringWithKey:@"dateCheckOut" WithValue:[TheAppDelegate.hotelSearchForm.checkoutDate chineseDescription]];
    [parameterManager parserStringWithKey:@"brands" WithValue:[Brand getStarHotelBrandCodes]];
    [parameterManager parserStringWithKey:@"areaName" WithValue:TheAppDelegate.hotelSearchForm.area];
    [parameterManager parserStringWithKey:@"starRatings" WithValue:TheAppDelegate.hotelSearchForm.starLevel.code];
    [parameterManager parserFloatWithKey:@"latitude" WithValue:TheAppDelegate.hotelSearchForm.searchPoint.latitude];
    [parameterManager parserFloatWithKey:@"longitude" WithValue:TheAppDelegate.hotelSearchForm.searchPoint.longitude];
    [parameterManager parserIntegerWithKey:@"pageIndex" WithValue:pageIndex];
    
    CloNetworkUtil *cloNetworkUtil = [[CloNetworkUtil alloc] init];
    NetworkStatus workStatus = [cloNetworkUtil getNetWorkType];
    switch (workStatus) {
        case ReachableViaWiFi:
            [parameterManager parserIntegerWithKey:@"length" WithValue:kHotelPageSize_10];
            break;
        case ReachableViaWWAN:
            [parameterManager parserIntegerWithKey:@"length" WithValue:kHotelPageSize_5];
            break;
        default:
            [parameterManager parserIntegerWithKey:@"length" WithValue:kHotelPageSize_5];
            break;
    }
    
    [parameterManager parserStringWithKey:orderName WithValue:orderVal];
    [parameterManager parserStringWithKey:@"language" WithValue:NSLocalizedStringFromTable(@"language", @"HotelList", @"")];
    
    self.requestString = [parameterManager serialization];
    [self start];
}

@end
