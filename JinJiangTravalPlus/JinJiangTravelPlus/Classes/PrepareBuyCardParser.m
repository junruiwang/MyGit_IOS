//
//  PrepareBuyCardParser.m
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-5-22.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "PrepareBuyCardParser.h"
#import "GDataXMLNode.h"
#import "ParameterManager.h"
#import "BuyCardForm.h"
#import "PrepareBuyCardForm.h"


@implementation PrepareBuyCardParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString] )
    {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
        
        PrepareBuyCardForm *pbcForm = [[PrepareBuyCardForm alloc] init];
        pbcForm.message = [[rootElement firstElementForName:@"message"] stringValue];
        pbcForm.cardNo = [[rootElement firstElementForName:@"cardNo"] stringValue];
        pbcForm.orderNo = [[rootElement firstElementForName:@"orderNo"] stringValue];
        pbcForm.bgUrl = [[rootElement firstElementForName:@"bgUrl"] stringValue];
        pbcForm.code = [[rootElement firstElementForName:@"code"] stringValue];
        
        NSDictionary *data = @{@"pbcForm":pbcForm};
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {   [self.delegate parser:self DidParsedData:data]; }
    }
    return YES;
}


- (void)buyCardRequest:(BuyCardForm *)buyCardForm
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"provinceId" WithValue:buyCardForm.provinceId];
    [parameterManager parserStringWithKey:@"cityId" WithValue:buyCardForm.cityId];
    [parameterManager parserStringWithKey:@"districtId" WithValue:buyCardForm.districtId];
    [parameterManager parserStringWithKey:@"address" WithValue:buyCardForm.address];
    [parameterManager parserStringWithKey:@"certificateType" WithValue:buyCardForm.certificateType];
    [parameterManager parserStringWithKey:@"certificateNo" WithValue:buyCardForm.certificateNo];
    [parameterManager parserStringWithKey:@"channel" WithValue:@"Mobile"];
    [parameterManager parserStringWithKey:@"memberType" WithValue:@"J Benefit Card"];
    [parameterManager parserStringWithKey:@"amount" WithValue:buyCardForm.amount];
    [parameterManager parserStringWithKey:@"userName" WithValue:buyCardForm.userName];
    [parameterManager parserStringWithKey:@"postcode" WithValue:buyCardForm.postCode];
    
    self.serverAddress = kMemberPreBuyCardURL;
    
    self.requestString = [parameterManager serialization];
    
    [self start];
}

@end
