//
//  UnionPaymentParser.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/28/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "UnionPaymentParser.h"
#import "GDataXMLNode.h"
#import "ParameterManager.h"
#import "UnionPaymentResult.h"
#import "IPAddress.h"

@implementation UnionPaymentParser

-(id)init
{
    self = [super init];
    self.ipAddress = [IPAddress currentIPAddress];
    return self;
}

- (BOOL)parseXmlString:(NSString *)xmlString {
    if ([super parseXmlString:xmlString]) {
        NSError *error;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
        
        GDataXMLNode *codeNode = [rootElement attributeForName:kKeyCode];
        NSString *code = [codeNode stringValue];
        NSLog(@"======code is %@",code);
        if ([@"0" isEqualToString:code]) {
            GDataXMLElement *resultElem = [rootElement elementsForName:kKeyResult][0];
            GDataXMLElement *messageElem = [rootElement elementsForName:kKeyMessage][0];
            UnionPaymentResult *unionPaymentResult = [[UnionPaymentResult alloc] init];
            unionPaymentResult.status = [resultElem stringValue];
            unionPaymentResult.message = [messageElem stringValue];
            
            NSDictionary *data = @{@"unionPaymentResult" : unionPaymentResult};
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


-(void)paymentRequest:(UnionPaymentForm *) paymentForm
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"cardNo" WithValue:paymentForm.cardNo];
    [parameterManager parserStringWithKey:@"phone" WithValue:paymentForm.phone];
    [parameterManager parserStringWithKey:@"businessPart" WithValue:@"HOTEL"];
    [parameterManager parserStringWithKey:@"amount" WithValue:paymentForm.amount];
    [parameterManager parserStringWithKey:@"remark" WithValue:@" "];
    [parameterManager parserStringWithKey:@"orderNo" WithValue:paymentForm.orderNo];
    [parameterManager parserStringWithKey:@"description" WithValue:paymentForm.hotelName];
    [parameterManager parserStringWithKey:@"acqSsn" WithValue:paymentForm.trackNo];
    [parameterManager parserStringWithKey:@"buyerId" WithValue:paymentForm.userId];
    [parameterManager parserStringWithKey:@"buyerName" WithValue:paymentForm.userName];
    [parameterManager parserStringWithKey:@"buyerIpip" WithValue:self.ipAddress];
    [parameterManager parserStringWithKey:@"beneficiary" WithValue:paymentForm.userName];
    [parameterManager parserStringWithKey:@"beneficiaryPhone" WithValue:paymentForm.phone];
    if(paymentForm.isNewOrGrayPanel){
        [parameterManager parserStringWithKey:@"oa_name" WithValue:paymentForm.openingBankName];
        [parameterManager parserStringWithKey:@"oa_identifyNo" WithValue:paymentForm.openingBankIdentityNo];
        [parameterManager parserStringWithKey:@"oa_identifyType" WithValue:paymentForm.identifyType];
        [parameterManager parserStringWithKey:@"oa_phone" WithValue:paymentForm.openingBankPhone];
        [parameterManager parserStringWithKey:@"oa_address" WithValue:paymentForm.openingBankCityName];
    }
    
    self.requestString = [parameterManager serialization];
    self.serverAddress = kPaymentPayingURL;
    [self start];
    
}

@end
