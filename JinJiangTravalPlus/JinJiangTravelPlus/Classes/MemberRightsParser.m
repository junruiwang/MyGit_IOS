//
//  MemberRightsParser.m
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-4-17.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "MemberRightsParser.h"
#import "GDataXMLNode.h"
#import "ParameterManager.h"
#import "JSON.h"

@implementation MemberRightsParser

- (BOOL)parseXmlString:(NSString *)xmlString {
    if (xmlString !=nil) {
        
        @try {
            NSArray *array = [xmlString JSONValue];
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            [data setValue:array forKey:@"memberCardRights"];
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


-(void)getMemberRightsRequest
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    self.requestString = [parameterManager serialization];
    self.serverAddress = kMemberCardRightsURL;
    [self start];
}
@end
