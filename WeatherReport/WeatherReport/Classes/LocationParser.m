//
//  LocationParser.m
//  JinJiangTravalPlus
//
//  Created by 汪君瑞 on 12-11-9.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import "LocationParser.h"
#import "SBJson.h"
#import "Constants.h"

@implementation LocationParser

- (BOOL)parserJSONString:(NSString *)responseData
{
    if(responseData != nil)
    {
        NSDictionary *dictionary = [responseData JSONValue];
        [self.delegate parser:self DidParsedData:dictionary];
    }
    return YES;
}

- (void)reverseGeocodingPosition:(NSString *)criteria
{
    NSString *str = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder?output=json&location=%@&key=%@", criteria, kBaiduKey];
    self.serverAddress = str;
    [self start];
}

@end
