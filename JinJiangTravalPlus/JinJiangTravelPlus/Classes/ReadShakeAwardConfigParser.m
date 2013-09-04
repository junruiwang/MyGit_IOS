//
//  ReadShakeAwardConfParser.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 5/30/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "ReadShakeAwardConfigParser.h"
#import "ParameterManager.h"
#import "GDataXMLNode.h"

@implementation ReadShakeAwardConfigParser

- (BOOL)parseXmlString:(NSString *)xmlString {
    if ([super parseXmlString:xmlString]) {
        NSError *error = nil;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        NSDictionary *data = nil;
        if (!error) {
            GDataXMLElement *rootElement = [document rootElement];
            NSString *status = [[rootElement elementsForName:kKeyStatus][0] stringValue];
            NSString *enabled = [[rootElement elementsForName:kKeyEnabled][0] stringValue];
            NSString *shakeAwardDate = [[rootElement elementsForName:kKeyDateStr][0] stringValue];
            data = @{kKeyStatus : status, kKeyEnabled : enabled,kKeyDateStr:shakeAwardDate};
        }

        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)]) {
            [self.delegate parser:self DidParsedData:data];
        }
    }
    return YES;
}


- (void)getShakeAwardConfig:(NSString *)dayLotteryNum {
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"dayLotteryNum" WithValue:dayLotteryNum];
    self.requestString = [parameterManager serialization];
    self.serverAddress = kReadShakeAwardConfigURL;
    [self start];
}
@end
