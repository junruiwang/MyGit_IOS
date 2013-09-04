//
//  PassbookRequestParse.m
//  JinJiangTravelPlus
//
//  Created by huguiqi on 13-1-31.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "PassbookRequestParse.h"
#import "ParameterManager.h"
#import "GDataXMLNode.h"
#import "OrderPassbookForm.h"
#import "Constants.h"
#import "NSDataAES.h"
#import "CardPassbookForm.h"

@implementation PassbookRequestParse

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
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement* rootElement = [document rootElement];
        GDataXMLNode* codeNode = [rootElement attributeForName:kKeyCode];
        NSString* code = [codeNode stringValue];
        GDataXMLElement* statusElem = [rootElement elementsForName:kKeyStatuss][0];
        NSString* status = [statusElem stringValue];
        
        if ([@"0" isEqualToString:code] && [status isEqualToString:@"SUCCESS"])
        {
            GDataXMLElement* passUrlElem = [rootElement elementsForName:kKeyPassUrl][0];
            NSString* passUrl = [passUrlElem stringValue];
            [self.passUrlDelegate getPassUr:passUrl];
        }
        else
        {
           [self.passUrlDelegate getPassUr:nil];
            return NO;
        }
    }
    return YES;
}

-(void)generateOrderPassbook:(OrderPassbookForm *)passbookForm
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"checkInDate" WithValue:passbookForm.checkInDate];
    [parameterManager parserStringWithKey:@"checkOutDate" WithValue:passbookForm.checkOutDate];
    [parameterManager parserStringWithKey:@"checkInPerson" WithValue:passbookForm.checkInPerson];
    [parameterManager parserStringWithKey:@"orderNo" WithValue:passbookForm.orderNo];
    [parameterManager parserStringWithKey:@"hotelName" WithValue:passbookForm.hotelName];
    [parameterManager parserStringWithKey:@"hotelBrand" WithValue:passbookForm.hotelBrand];
    [parameterManager parserStringWithKey:@"nightsNum" WithValue:passbookForm.nightsNum];
    [parameterManager parserStringWithKey:@"roomType" WithValue:passbookForm.roomType];
    [parameterManager parserStringWithKey:@"latitude" WithValue:passbookForm.latitude];
    [parameterManager parserStringWithKey:@"longitude" WithValue:passbookForm.longitude];
    [parameterManager parserStringWithKey:@"hotelAddress" WithValue:passbookForm.hotelAddress];
    [parameterManager parserStringWithKey:@"orderAmount" WithValue:passbookForm.orderAmount];

    self.requestString = [parameterManager serialization];
    self.serverAddress = KGetOrderPassbookURL;
    [self start];
}

-(void)generateCardPassbook:(CardPassbookForm *)passbookForm
{
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"cardNo" WithValue:passbookForm.cardNo];
    [parameterManager parserStringWithKey:@"cardType" WithValue:passbookForm.cardType];
    [parameterManager parserStringWithKey:@"customerName" WithValue:passbookForm.userName];
    [parameterManager parserStringWithKey:@"score" WithValue:passbookForm.score];
    
    self.requestString = [parameterManager serialization];
    self.serverAddress = KGetCardPassbookURL;
    [self start];
}


- (void)start
{
    
    {
        [self cancel];
        [_requestData resetBytesInRange:NSMakeRange(0, [_requestData length])];
        [_requestData setLength:0];
        
        NSString* uid = TheAppDelegate.userInfo.uid;
        NSString* httpBodyString = @"";
        if (self.requestString !=nil && ![self.requestString isEqualToString:@""])
        {   httpBodyString = [NSString stringWithFormat:@"%@&clientVersion=%@&userId=%@", self.requestString, kClientVersion, uid]; }
        else
        {   httpBodyString = [NSString stringWithFormat:@"clientVersion=%@&userId=%@", kClientVersion, uid];    }
        httpBodyString = [httpBodyString stringByAppendingFormat:@"&sign=%@", [[uid stringByAppendingFormat:kSecurityKey] MD5String]];
        
        if(self.isHTTPGet == YES)
        {
            NSString* url = [NSString stringWithFormat:@"%@?%@", self.serverAddress, httpBodyString];
            NSLog(@"%s get:%@", __FUNCTION__, url);
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
            
            NSURLResponse *response = nil;
            NSError *error = nil;

            _requestData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]];
                            
            NSString* xmlString = [[NSString alloc] initWithData:_requestData encoding:NSUTF8StringEncoding];
            [self parseXmlString:xmlString];
            [self cancel];
            
        }
        else
        {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            NSLog(@"%s full url:[%@?%@]", __FUNCTION__, self.serverAddress, httpBodyString);
            [request setTimeoutInterval:30]; // default is 60s
            [request setURL:[NSURL URLWithString:self.serverAddress]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
            [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
            
            _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            NSURLResponse *response = nil;
            NSError *error = nil;
            
            _requestData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]];
            
            NSString* xmlString = [[NSString alloc] initWithData:_requestData encoding:NSUTF8StringEncoding];
            [self parseXmlString:xmlString];
            [self cancel];
        }
    }
}
    
@end
