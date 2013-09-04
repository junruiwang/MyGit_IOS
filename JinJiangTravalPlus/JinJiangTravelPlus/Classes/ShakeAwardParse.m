//
// Created by 胡 桂祁 on 5/31/13.
// Copyright (c) 2013 JinJiang. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ShakeAwardParse.h"
#import "GDataXMLNode.h"
#import "ParameterManager.h"


@implementation ShakeAwardParse {

}

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString])
    {
        NSError* error = nil;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        NSDictionary *data = [[NSMutableDictionary alloc] initWithCapacity:5];
        if (!error) {
            GDataXMLElement* rootElement = [document rootElement];
            GDataXMLNode *codeNode = [rootElement attributeForName:kKeyCode];
            int codeValue = [codeNode intValue];
            if(codeValue == 0){
                NSString *status = [[rootElement elementsForName:kKeyStatus][0] stringValue];
                NSString *awardDesc = [[rootElement elementsForName:kKeyAward][0] stringValue];
                NSString *activeStatus = [[rootElement elementsForName:kKeyActiveStatus][0] stringValue];
                NSString *activeEnabled = [[rootElement elementsForName:kKeyEnabled][0] stringValue];
                NSString *prizeRecordId = [[rootElement elementsForName:kKeyPrizeRecordId][0] stringValue];
                NSString *awardType = [[rootElement elementsForName:kKeyAwardType][0] stringValue];
                
                data = @{kKeyAward: awardDesc,kKeyStatus:status,kKeyActiveStatus:activeStatus,kKeyEnabled:activeEnabled,kKeyPrizeRecordId:prizeRecordId,kKeyAwardType:awardType};
            }
        }
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {
            [self.delegate parser:self DidParsedData:data];
        }
    
    }
    return YES;
}


- (void)shakeAward:(NSString*) dayLotteryNum withActivityCode:(NSString *)activity
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"dayLotteryNum" WithValue:dayLotteryNum];

    [parameterManager parserStringWithKey:@"activeCode" WithValue:activity];
    self.requestString = [parameterManager serialization];
    self.serverAddress = kShakeAwardURL;
    [self startSynchronous];
}
@end