//
//  CpaManagerParser.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 4/1/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "CpaManagerParser.h"
#import "GDataXMLNode.h"
#import "ParameterManager.h"

@implementation CpaManagerParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString] ) {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement* rootElement = [document rootElement];
        GDataXMLElement* statusElement = [[rootElement elementsForName:@"status"] objectAtIndex:0];
        NSString *status = [statusElement stringValue];
        NSString *message = @"cpa mac地址保存成功!!";
        if (!status && [@"FAIL" isEqualToString:status]){
            message = @"cpa mac地址保存失败!!";
        }
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:status, @"status", message, @"message", nil];
        
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
            [self.delegate parser:self DidParsedData:data];
    }
    return YES;
}



-(void)saveActiveMacAddress:(NSString *)macAddress deviceToken: (NSString *)deviceToken
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"macAddress" WithValue:macAddress];
    [parameterManager parserStringWithKey:@"deviceToken" WithValue:deviceToken];
    self.requestString = [parameterManager serialization];
    self.serverAddress = kCpaSaveURL;
    [self start];
}

@end
