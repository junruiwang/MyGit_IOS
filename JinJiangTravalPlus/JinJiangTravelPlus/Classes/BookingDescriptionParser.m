//
//  BookingDescriptionParser.m
//  JinJiangTravelPlus
//
//  Created by Rong Hao on 13-7-31.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "BookingDescriptionParser.h"
#import "ParameterManager.h"
#import "GDataXMLNode.h"

@implementation BookingDescriptionParser


- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString])
    {
        NSError* error;
        
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement* rootElement = [document rootElement];
        
        int isOpen = [[rootElement firstElementForName:@"isOpen"] intValue];
        NSString *description = [[rootElement firstElementForName:@"description"] stringValue];
        NSString *activityArriveTime = [[rootElement firstElementForName:@"activityArriveTime"] stringValue];
        NSString *payFeedBackDesc = [[rootElement firstElementForName:@"payFeedBackDesc"] stringValue];
        if (isOpen != 1) {
            return NO;
        }
        NSDictionary* data = @{@"description":description, @"activityArriveTime":activityArriveTime, @"payFeedBackDesc":payFeedBackDesc};
        NSLog(@"data = %@", [data description]);
        
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {
            [self.delegate parser:self DidParsedData:data];
        }
    }
    return YES;
}


- (void)sendRequest:(NSString *)hotelBrand
{
    if ([@"BESTAY" isEqualToString:hotelBrand])return;
    
    self.serverAddress = kBookingDescription;
    
    [self start];
}
@end
