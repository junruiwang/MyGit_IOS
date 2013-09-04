//
//  AlipayParser.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-5-29.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "AlipayParser.h"
#import "GDataXMLNode.h"
#import "ParameterManager.h"

@implementation AlipayParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString] )
    {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
        
        NSString *payInfo = [[rootElement firstElementForName:@"payInfo"] stringValue];
        NSDictionary *data = @{@"payInfo":payInfo};
        
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {   [self.delegate parser:self DidParsedData:data]; }
    }
    return YES;
}

-(void)payment:(AlipayForm *)form
{
    self.serverAddress = KAliPayClientURL;
    
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"orderNo" WithValue:form.orderNo];
    [parameterManager parserStringWithKey:@"subject" WithValue:form.subject];
    [parameterManager parserStringWithKey:@"description" WithValue:form.description];
    [parameterManager parserStringWithKey:@"bgUrl" WithValue:form.bgUrl];
    [parameterManager parserStringWithKey:@"payAmount" WithValue:form.amount];
    [parameterManager parserStringWithKey:@"businessPart" WithValue:form.businessPart];
    [parameterManager parserStringWithKey:@"buyerName" WithValue:form.buyerName];
    [parameterManager parserStringWithKey:@"buyerIp" WithValue:form.buyerIp];
    
    self.requestString = [parameterManager serialization];
    [self start];
}

@end
