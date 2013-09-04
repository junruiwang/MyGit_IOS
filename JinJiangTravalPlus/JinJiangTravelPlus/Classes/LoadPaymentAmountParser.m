//
//  LoadPaymentAmountParser.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 1/4/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "LoadPaymentAmountParser.h"
#import "GDataXMLNode.h"
#import "ParameterManager.h"

@implementation LoadPaymentAmountParser

- (BOOL)parseXmlString:(NSString *)xmlString {
    if ([super parseXmlString:xmlString]) {
        NSError *error;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
        
        GDataXMLNode *codeNode = [rootElement attributeForName:kKeyCode];
        NSString *code = [codeNode stringValue];
    
        if ([@"0" isEqualToString:code]) {

            GDataXMLElement *paymentAmountElem = [rootElement elementsForName:kKeyPaymentAmount][0];
            NSString *paymentAmount = [paymentAmountElem stringValue];

            NSDictionary *data = @{@"paymentAmount" : paymentAmount};
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
                [self.delegate parser:self DidParsedData:data];
        } else {
            NSString *message = [[rootElement elementsForName:kKeyMessage][0] stringValue];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:)])
                [self.delegate parser:self DidFailedParseWithMsg:message errCode:[code intValue]];
            return NO;
        }
    }
    return YES;
}


-(void)loadPaymentAmount:(NSString *)orderNo;
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    self.requestString = [parameterManager serialization];
    self.serverAddress = [kHotelOrderPlaceURL stringByAppendingPathComponent:orderNo];
    [self start];
}
@end
