//
//  LocationParser.m
//  JinJiangTravalPlus
//
//  Created by 汪君瑞 on 12-11-9.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import "LocationParser.h"
#import "GDataXMLNode.h"
#import "SBJson.h"
#import "Constants.h"

@implementation LocationParser

- (BOOL)parseXmlString:(NSString*)xmlString
{
    if(xmlString != nil)
    {
        NSDictionary *dictionary = [xmlString JSONValue];
        [self.delegate parser:self DidParsedData:dictionary];
    }
    return YES;
}

- (void)start
{
    [self cancel];
    [_requestData resetBytesInRange:NSMakeRange(0, [_requestData length])];
    [_requestData setLength:0];
    NSString* url = [NSString stringWithFormat:@"%@?%@", self.serverAddress, self.requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [_connection start];
}

- (void)reverseGeocodingPosition:(NSString *)criteria isGetingCityName:(BOOL)getingCityName
{
    self.serverAddress = @"http://api.map.baidu.com/geocoder";
    NSString* str = [NSString stringWithFormat:@"output=json&location=%@&key=%@", criteria, kBaiduKey];
    self.requestString = str;
    self.isHTTPGet = YES;
    [self start];
}

@end
