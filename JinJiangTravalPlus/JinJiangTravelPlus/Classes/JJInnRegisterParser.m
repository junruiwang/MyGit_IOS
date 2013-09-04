//
//  JJInnRegisterParser.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-21.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "JJInnRegisterParser.h"
#import "GDataXMLNode.h"

@implementation JJInnRegisterParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString] ) {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement* rootElement = [document rootElement];
        GDataXMLElement* statusElement = [[rootElement elementsForName:@"status"] objectAtIndex:0];
        GDataXMLElement* messageElement = [[rootElement elementsForName:@"message"] objectAtIndex:0];
        NSString *status = [statusElement stringValue];
        if (!status)
        {   status = @"";   }
        NSString *message = [messageElement stringValue];
        if (!message)
        {   message = @"";  }
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:status, @"status", message, @"message", nil];
        
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {   [self.delegate parser:self DidParsedData:data]; }
    }
    
    return YES;
}

@end
