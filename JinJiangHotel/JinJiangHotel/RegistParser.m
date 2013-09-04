//
//  RegistParser.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-19.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "RegistParser.h"
#import "GDataXMLNode.h"

@implementation RegistParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString] ) {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
        NSString *userId = [[rootElement firstElementForName:@"userId"] stringValue];
        
        NSDictionary *data = @{@"userId":userId};
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
            [self.delegate parser:self DidParsedData:data];
        
    }
    return YES;
}

@end
