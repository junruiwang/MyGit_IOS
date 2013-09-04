//
//  RenewCardParser.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 7/29/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "RenewCardParser.h"
#import "ParameterManager.h"

@implementation RenewCardParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString])
    {
        NSError *error;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
        GDataXMLNode *codeNode = [rootElement attributeForName:kKeyCode];
        NSString *code = [codeNode stringValue];
        if ([@"0" isEqualToString:code])
        {
            NSString *status = [[rootElement elementsForName:kKeyStatus][0] stringValue];
            NSString *orderNo = [[rootElement elementsForName:kKeyOrderNo][0] stringValue];
            if([@"SUCCESS" isEqualToString:status]){
                NSDictionary *data = @{kKeyOrderNo : orderNo};
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
                    [self.delegate parser:self DidParsedData:data];
            }else{
                NSString *message = @"对不起，您的续费生成订单失败，请稍后再试或者致电1010-1666询问详情~";
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:)])
                    [self.delegate parser:self DidFailedParseWithMsg:message errCode:-1];
                return NO;

            }
            
        }else{
            NSString *message = [[rootElement elementsForName:kKeyMessage][0] stringValue];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:)])
                [self.delegate parser:self DidFailedParseWithMsg:message errCode:[code intValue]];
            return NO;
        }
    }
    return YES;
}

-(void)createOrder:(NSString *) cardNo
{
    self.serverAddress = kRenewCardOrderURL;
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"cardNo" WithValue:cardNo];
    [parameterManager parserStringWithKey:@"isTempMember" WithValue:TheAppDelegate.userInfo.isTempMember];
    self.requestString = [parameterManager serialization];
    [self start];
}

@end
