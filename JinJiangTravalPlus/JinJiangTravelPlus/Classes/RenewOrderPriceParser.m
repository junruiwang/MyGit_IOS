//
//  RenewOrderPayParser.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 7/29/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "RenewOrderPriceParser.h"
#import "ParameterManager.h"
#import "GDataXMLNode.h"

@implementation RenewOrderPriceParser

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
            NSString *amount = [[rootElement elementsForName:kKeyAmount][0] stringValue];
            NSString *orderNo = [[rootElement elementsForName:kKeyOrderNo][0] stringValue];
            NSString *bgUrl = [[rootElement elementsForName:kKeyBgUrl][0] stringValue];
          
            NSDictionary *data = @{kKeyOrderNo : orderNo,kKeyAmount:amount,kKeyBgUrl:bgUrl};
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
                    [self.delegate parser:self DidParsedData:data];
                      
        }else{
            NSString *message = [[rootElement elementsForName:kKeyMessage][0] stringValue];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:)])
                [self.delegate parser:self DidFailedParseWithMsg:message errCode:[code intValue]];
            return NO;
        }
    }
    return YES;
}

-(void)getOrderPayInfo:(NSString *) orderNo
{
    self.serverAddress = [kRenewGetPayInfoURL stringByAppendingPathComponent:orderNo];
    [self start];
}

@end
