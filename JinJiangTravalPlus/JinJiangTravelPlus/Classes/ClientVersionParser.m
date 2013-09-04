//
//  ClientVersionParser.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-14.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "ClientVersionParser.h"
#import "GDataXMLNode.h"
#import "ClientVersion.h"

@implementation ClientVersionParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString] )
    {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
        ClientVersion *clientVersion = [[ClientVersion alloc] init];
        clientVersion.version = [[rootElement attributeForName:@"version"] stringValue];
        clientVersion.userId = [[rootElement attributeForName:@"userId"] stringValue];
        clientVersion.forceUpdate = [[rootElement attributeForName:@"forceUpdate"] stringValue];
        clientVersion.updateUrl = [[rootElement firstElementForName:@"updateUrl"] stringValue];
        clientVersion.commentUrl = [[rootElement firstElementForName:@"commentUrl"] stringValue];
        clientVersion.reason = [[rootElement firstElementForName:@"reason"] stringValue];
        clientVersion.description = [[rootElement firstElementForName:@"description"] stringValue];

        NSDictionary *data = @{@"clientVersion":clientVersion};
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {   [self.delegate parser:self DidParsedData:data]; }
        
    }
    return YES;
}

@end
