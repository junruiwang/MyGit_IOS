//
//  PayerVerifyParser.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/28/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "PayerVerifyParser.h"
#import "GDataXMLNode.h"
#import "ParameterManager.h"
#import "PayerVerifyResult.h"

@implementation PayerVerifyParser

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
            GDataXMLElement *resultElem = [rootElement elementsForName:kKeyResult][0];
            GDataXMLElement *trackNoElem = [rootElement elementsForName:kKeySysTrackNo][0];
            PayerVerifyResult *payerVerifyResult = [[PayerVerifyResult alloc] init];
            payerVerifyResult.verifyResult=[resultElem stringValue];
            payerVerifyResult.trackNo = [trackNoElem stringValue];
            
            NSDictionary *data = @{@"payerVerifyResult" : payerVerifyResult};
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
                [self.delegate parser:self DidParsedData:data];
        }
        else
        {
            NSString *message = [[rootElement elementsForName:kKeyMessage][0] stringValue];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidFailedParseWithMsg:)])
            {   [self.delegate parser:self DidFailedParseWithMsg:message errCode:[code intValue]];  }
            return NO;
        }
    }
    return YES;
}


-(void)verifyRequest:(PayerVerifyForm *) payerVerifyForm
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"cardNo" WithValue:payerVerifyForm.cardNo];
    [parameterManager parserStringWithKey:@"phone" WithValue:payerVerifyForm.phone];
    [parameterManager parserStringWithKey:@"businessPart" WithValue:@"HOTEL"];
    self.requestString = [parameterManager serialization];
    self.serverAddress = kPaymentVerifyURL;
    [self start];
}

- (void)loadPaymentAmountRequest
{

}

- (void)paymentRequest
{

}

@end
