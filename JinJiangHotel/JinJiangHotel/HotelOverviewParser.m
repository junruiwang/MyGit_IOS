//
//  HotelOverviewParser.m
//  JinJiangTravelPlus
//
//  Created by Leon on 11/19/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "HotelOverviewParser.h"
#import "GDataXMLNode.h"
#import "JJHotel.h"
#import "Constants.h"

@implementation HotelOverviewParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString])
    {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
        GDataXMLElement *hotelElement = [rootElement firstElementForName:@"hotel"];
        const int hotelId = [[hotelElement attributeForName:@"id"] intValue];
        NSString *description = [[hotelElement firstElementForName:@"description"] stringValue];
        NSString *policyInfo = [[hotelElement firstElementForName:@"policyInfo"] stringValue];
        NSString *diningFacilities = [[hotelElement firstElementForName:@"diningFacilities"] stringValue];
        NSString *locationInfo = [[hotelElement firstElementForName:@"locationInfo"] stringValue];
        const float lat = [[hotelElement firstElementForName:@"latitude"] floatValue];
        const float lng = [[hotelElement firstElementForName:@"longitude"] floatValue];
        const int star = [JJHotel starFromName:[[hotelElement firstElementForName:@"starRating"] stringValue]];
        NSString *address   = [[hotelElement firstElementForName:@"address"] stringValue];
        NSString *telphone = [[hotelElement firstElementForName:@"tel"] stringValue];
        NSString *facadeUrl = [[[hotelElement firstElementForName:@"facadeUrl"] stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *name = [[hotelElement firstElementForName:@"name"] stringValue];
        NSString *cityName = [[hotelElement firstElementForName:@"city"] stringValue];
        JJHotelBrand brand = [JJHotel brandFromName:[[hotelElement firstElementForName:@"brand"] stringValue]];
        GDataXMLElement *imagesElement = [hotelElement firstElementForName:@"images"];
        NSString *imagesString = @"";
        NSArray *images = [imagesElement elementsForName:@"image"];
        if ([images count] >= 2)
        {
            for (unsigned int i = 0; i < [images count] - 1; i++)
            {
                GDataXMLElement *image = [images objectAtIndex:i];
                NSString *tit = [[image attributeForName:@"title"] stringValue];
                NSString *url = [[image firstElementForName:@"url"] stringValue];
                imagesString = [imagesString stringByAppendingFormat:@"%@,%@;", tit, url];
            }
            {
                GDataXMLElement *image = [images objectAtIndex:([images count] - 1)];
                NSString *tit = [[image attributeForName:@"title"] stringValue];
                NSString *url = [[image firstElementForName:@"url"] stringValue];
                imagesString = [imagesString stringByAppendingFormat:@"%@,%@", tit, url];
            }
        }
        else
        {
            {
                GDataXMLElement *image = [images objectAtIndex:0];
                NSString *tit = [[image attributeForName:@"title"] stringValue];
                NSString *url = [[image firstElementForName:@"url"] stringValue];
                imagesString = [imagesString stringByAppendingFormat:@"%@,%@", tit, url];
            }
        }
        JJHotel *hotel = [[JJHotel alloc] init];
        hotel.hotelId = hotelId;
        hotel.name = name;
        hotel.imageUrl = facadeUrl;
        hotel.address = address;
        hotel.telphone = telphone;
        hotel.coordinate = CLLocationCoordinate2DMake(lat, lng);
        hotel.star = star;        
        hotel.cityName = cityName;
        hotel.brand = brand;
        const CLLocation *destination = [[CLLocation alloc] initWithLatitude:TheAppDelegate.hotelSearchForm.searchPoint.latitude
                                                                   longitude:TheAppDelegate.hotelSearchForm.searchPoint.longitude];
        CLLocation *hotelPositon = [[CLLocation alloc] initWithLatitude:hotel.coordinate.latitude longitude:hotel.coordinate.longitude];
        hotel.distance = [hotelPositon distanceFromLocation:(const CLLocation *)destination] / 1000;
        
        UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:facadeUrl]]];
        if (img == nil) {
            img = [UIImage imageNamed:@"defaultHotelIcon.png"];
        }
        hotel.icon = img;
        
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {
            [self.delegate parser:self DidParsedData:@{@"description":description, @"policyInfo":policyInfo,
             @"diningFacilities":diningFacilities, @"locationInfo":locationInfo, @"images":imagesString, @"hotel":hotel}];
        }
    }
    return YES;
}

@end
