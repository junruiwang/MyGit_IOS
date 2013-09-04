//
//  UserFeedbackParser.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 13-1-8.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "UserFeedbackParser.h"
#import "GDataXMLNode.h"

@implementation UserFeedbackParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    //NSLog(@"xmlString = %@", xmlString);

    {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement* rootElement = [document rootElement];

        NSString* status = [[rootElement firstElementForName:@"status"] stringValue];

        if (status)
        {
            NSDictionary* data = @{@"status":status};
            
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
            {   [self.delegate parser:self DidParsedData:data]; }
        }
        else
        {
            NSDictionary* data = @{@"status":@"XX"};

            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
            {   [self.delegate parser:self DidParsedData:data]; }
        }
    }

    return YES;
}

@end
