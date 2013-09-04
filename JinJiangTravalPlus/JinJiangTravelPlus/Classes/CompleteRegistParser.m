//
//  CompleteRegistParser.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-1-7.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "CompleteRegistParser.h"
#import "GDataXMLNode.h"

@implementation CompleteRegistParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString] ) {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
        NSString *status = [[rootElement firstElementForName:@"status"] stringValue];
        
        NSDictionary *data = @{@"status":status};
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
            [self.delegate parser:self DidParsedData:data];
        
    }
    return YES;
}

@end
