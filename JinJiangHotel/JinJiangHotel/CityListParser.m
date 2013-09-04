//
//  CityListParser.m
//  
//
//  Created by Li Peng on 10-9-10.
//  Copyright 2010 JinJiang. All rights reserved.
//

#import "CityListParser.h"
#import "GDataXMLNode.h"
#import "City.h"

@implementation CityListParser

- (BOOL)parseXmlString:(NSString *)xmlString
{    
    if ([super parseXmlString:xmlString] )
    {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];

        if ([rootElement elementsForName:@"cities"] == nil || [[rootElement elementsForName:@"cities"] count] == 0)
        {   return NO;  }

        GDataXMLElement* citiesElement = [rootElement elementsForName:@"cities"][0];
        NSArray* cities = [citiesElement elementsForName:@"city"];

        if (cities == nil || [cities count] == 0)   {   return NO;  }

        NSMutableArray* citiesList = [[NSMutableArray alloc] init];
        City* city;

        for (GDataXMLElement *cityElement in cities)
        {
            NSString* namePinYing = [[cityElement elementsForName:@"namePinyin"] [0] stringValue];
            NSString* name=[[cityElement elementsForName:@"name"][0] stringValue];

            const float latitude = [[cityElement elementsForName:@"latitude"][0] floatValue];
            const float longitude= [[cityElement elementsForName:@"longitude"][0] floatValue];

            city = [[City alloc] init];
            city.name = name;
            city.namePinyin = namePinYing;
            city.longitude = longitude;
            city.latitude = latitude;
            [citiesList addObject:city];
        }

        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:citiesList, @"cityList", nil];

        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {   [self.delegate parser:self DidParsedData:data]; }
    }
    return YES;
}
@end
