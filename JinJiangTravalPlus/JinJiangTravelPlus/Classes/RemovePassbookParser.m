//
//  RemovePassbookParser.m
//  JinJiangTravelPlus
//
//  Created by huguiqi on 13-2-5.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "RemovePassbookParser.h"
#import "ParameterManager.h"
#import "GDataXMLNode.h"

@implementation RemovePassbookParser

-(id)init
{
    self = [super init];
    self.delegate = self;
    return self;
}

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
            GDataXMLElement *statusElem = [rootElement elementsForName:kKeyStatuss][0];
            NSString *status = [statusElem stringValue];NSLog(@"=====status is:%@",status);
            return YES;
        }
    }
    return NO;
}

-(void)request:(OrderPassbookForm *)passbookForm
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"orderNo" WithValue:passbookForm.orderNo];

    self.requestString = [parameterManager serialization];
    self.serverAddress = KRemovePassbookURL;
    //NSLog([NSString stringWithFormat:@"orderNo:%@----passbook删除时间：%f", passbookForm.orderNo, [[NSDate date] timeIntervalSince1970]]);
    [self start];
}

@end
