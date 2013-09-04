//
//  ActivateJJInnMemberParser.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-18.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "ActivateJJInnMemberParser.h"
#import "GDataXMLNode.h"

@implementation ActivateJJInnMemberParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString])
    {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement* rootElement = [document rootElement];
        GDataXMLElement* statusElement = [[rootElement elementsForName:@"status"] objectAtIndex:0];
        GDataXMLElement* messageElement = [[rootElement elementsForName:@"message"] objectAtIndex:0];
        GDataXMLElement* mobileElement = [[rootElement elementsForName:@"mobile"] objectAtIndex:0];
        GDataXMLElement* emailElement = [[rootElement elementsForName:@"email"] objectAtIndex:0];
        NSString *status = [statusElement stringValue];
        if (!status)
        {   status = @"";   }
        NSString *message = [messageElement stringValue];
        if (!message)
        {   message = @"";  }
        NSString *mobile = [mobileElement stringValue];
        if (!mobile)
        {   mobile = @"";   }
        NSString *email = [emailElement stringValue];
        if (!email)
        {   email = @"";    }

        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:status, @"status",
                              message, @"message", mobile, @"mobile", email, @"email", nil];

        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {   [self.delegate parser:self DidParsedData:data]; }
    }
    
    return YES;
}

@end
