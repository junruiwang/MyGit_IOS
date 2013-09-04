//
//  WinnerInfoParser.m
//  JinJiangTravelPlus
//
//  Created by Rong Hao on 13-8-7.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "WinnerInfoParser.h"
#import "ParameterManager.h"

@implementation WinnerInfoParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString])
    {
        NSError* error = nil;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        NSDictionary *data = [[NSMutableDictionary alloc] initWithCapacity:5];
        if (!error) {
            GDataXMLElement* rootElement = [document rootElement];
            GDataXMLNode *codeNode = [rootElement attributeForName:@"code"];
            int codeValue = [codeNode intValue];
            if(codeValue == 0){
                
                data = @{@"status":@"ok"};
            }
        }
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {
            [self.delegate parser:self DidParsedData:data];
        }
        
    }
    return YES;
}


- (void)sendWinnerName:(NSString*)winnerName phoneNumber:(NSString *)phoneNumber address:(NSString *)address prizeRecordId:(NSString *)prizeRecordId
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"name" WithValue:winnerName];
    [parameterManager parserStringWithKey:@"phone" WithValue:phoneNumber];
    [parameterManager parserStringWithKey:@"address" WithValue:address];
    [parameterManager parserStringWithKey:@"prizeRecordId" WithValue:prizeRecordId];

    
    self.requestString = [parameterManager serialization];
    self.serverAddress = kCarnivalConsignee;
    [self start];
}

@end
