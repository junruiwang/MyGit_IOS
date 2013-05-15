//
//  WeatherWeekDayParser.m
//  WeatherReport
//
//  Created by jerry on 13-5-15.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "WeatherWeekDayParser.h"

@implementation WeatherWeekDayParser

- (BOOL)parserJSONString:(NSString *)responseData
{
    if ([super parserJSONString:responseData]) {
        NSDictionary *dictionary = [responseData JSONValue];
        
        NSDictionary *weatherinfo = [dictionary valueForKey:@"weatherinfo"];
                
        //NSDictionary *data = @{@"data":busLineOnlyArry, @"busLineArry":busLineArry};
        
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)]){
            [self.delegate parser:self DidParsedData:weatherinfo];
        }
    }
    return YES;
}

@end
