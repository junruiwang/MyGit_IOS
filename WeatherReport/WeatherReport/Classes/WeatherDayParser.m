//
//  WeatherDayParser.m
//  WeatherReport
//
//  Created by 汪君瑞 on 13-6-1.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "WeatherDayParser.h"

@implementation WeatherDayParser

- (BOOL)parserJSONString:(NSString *)responseData
{
    if ([super parserJSONString:responseData]) {
        NSDictionary *dictionary = [responseData JSONValue];
        NSDictionary *weatherinfo = [dictionary valueForKey:@"weatherinfo"];
        ModelWeather *weather = [[ModelWeather alloc] init];
        
        weather._1city = [weatherinfo valueForKey:@"city"];
        weather._2cityid = [weatherinfo valueForKey:@"cityid"];
        weather._3time = [weatherinfo valueForKey:@"time"];
        weather._4temp = [weatherinfo valueForKey:@"temp"];
        weather._5WD = [weatherinfo valueForKey:@"WD"];
        weather._6WS = [weatherinfo valueForKey:@"WS"];
        weather._7SD = [weatherinfo valueForKey:@"SD"];
        
        NSDictionary *data = @{@"data":weather};
        
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)]){
            [self.delegate parser:self DidParsedData:data];
        }
    }
    return YES;
}

@end
