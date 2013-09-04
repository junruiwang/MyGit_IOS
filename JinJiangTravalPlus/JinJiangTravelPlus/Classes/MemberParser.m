//
//  MemberParser.m
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 13-4-10.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "MemberParser.h"
#import "ParameterManager.h"
#import "GDataXMLNode.h"

@implementation MemberParser

- (void) search:(NSString *)mobile
{
    if (mobile == nil || [mobile isEqualToString:@""]) {
        return;
    }
    self.serverAddress = [[kIsMemberURL stringByAppendingString:@"/"] stringByAppendingString:mobile];
    [self start];
}

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString])
    {
        NSError* error;

        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement* rootElement = [document rootElement];

        GDataXMLElement* firstChildElement = [rootElement firstElementForName:@"isMember"];
        NSString* isMember = [firstChildElement stringValue];

        NSDictionary* data = @{@"isMember":isMember}; NSLog(@"data = %@", [data description]);

        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {
            [self.delegate parser:self DidParsedData:data];
        }
    }
    return YES;
}

@end
