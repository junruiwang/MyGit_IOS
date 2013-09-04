//
//  OrderCancelParser.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-27.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "OrderCancelParser.h"
#import "GDataXMLNode.h"
#import "HotelOrder.h"
#import "OderDetail.h"

@implementation OrderCancelParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    //if ([super parseXmlString:xmlString])
    {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement* rootElement = [document rootElement];

        NSString* message = [[rootElement firstElementForName:@"message"] stringValue];

        NSDictionary* data = @{@"message":message};

        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {   [self.delegate parser:self DidParsedData:data]; }
    }
    return YES;
}

@end
