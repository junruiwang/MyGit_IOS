//
//  BankCityListParser.m
//  JinJiangTravelPlus
//
//  Created by huguiqi on 13-1-3.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "BankCityListParser.h"
#import "GDataXMLNode.h"
#import "ParameterManager.h"
#import "JSON.h"

@implementation BankCityListParser


- (BOOL)parseXmlString:(NSString *)xmlString {
    if (xmlString !=nil) {
        
        @try {
              NSArray *array = [xmlString JSONValue];
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            [data setValue:array forKey:@"bankCityList"];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
            [self.delegate parser:self DidParsedData:data];
            
        } @catch (NSException *exception) {
            NSLog(@"------getBankCityList parse error!!----,%@",exception);
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:)])
                [self.delegate parser:self DidFailedParseWithMsg:@"获取服务器数据失败，请稍后再试" errCode:-1];
        } @finally {
            NSLog(@"------getBankCityList parse finish----");
        }
    }
    return YES;
}


-(void)getBankCityListRequest
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    self.requestString = [parameterManager serialization];
    self.serverAddress = kDepositBankCityListURL;
    [self start];
}

@end
