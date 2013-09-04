//
//  ReadActivityConfigParser.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-7-30.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "ReadActivityConfigParser.h"
#import "GDataXMLNode.h"
#import "ActiveConfig.h"

@implementation ReadActivityConfigParser

- (BOOL)parseXmlString:(NSString *)xmlString {
    if ([super parseXmlString:xmlString]) {
        NSError *error = nil;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        
        GDataXMLElement *rootElement = [document rootElement];
        ActiveConfig *activeConfig = [[ActiveConfig alloc] init];
        activeConfig.activeFlag = [[rootElement firstElementForName:@"activeFlag"] stringValue];
        activeConfig.title = [[rootElement firstElementForName:@"title"] stringValue];
        activeConfig.url = [[rootElement firstElementForName:@"url"] stringValue];
        activeConfig.prizeTitle = [[rootElement firstElementForName:@"prizeTitle"] stringValue];
        activeConfig.prizeDescription = [[rootElement firstElementForName:@"prizeDescription"] stringValue];
        
        NSDictionary *data = @{@"activeConfig":activeConfig};
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)]) {
            [self.delegate parser:self DidParsedData:data];
        }
    }
    return YES;
}

@end
