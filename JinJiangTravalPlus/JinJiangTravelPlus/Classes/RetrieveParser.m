//
//  RetrieveParser.m
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 13-1-31.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "RetrieveParser.h"
#import "GDataXMLNode.h"

@implementation RetrieveParser
- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString] )
    {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
        NSString *status = [[rootElement firstElementForName:@"status"] stringValue];

        NSDictionary *data = @{@"status":status};
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {   [self.delegate parser:self DidParsedData:data]; }
        
    }
    return YES;
}

@end
