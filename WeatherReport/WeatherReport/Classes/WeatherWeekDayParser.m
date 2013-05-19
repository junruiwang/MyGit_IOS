//
//  WeatherWeekDayParser.m
//  WeatherReport
//
//  Created by jerry on 13-5-15.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "WeatherWeekDayParser.h"
#import "ModelWeather.h"

@implementation WeatherWeekDayParser

- (BOOL)parserJSONString:(NSString *)responseData withObject:(id) object
{
    if ([super parserJSONString:responseData]) {
        NSDictionary *dictionary = [responseData JSONValue];
        NSDictionary *weatherinfo = [dictionary valueForKey:@"weatherinfo"];
        ModelWeather *weather = (ModelWeather *)object;
        if (weather._1city == nil || [weather._1city isEqualToString:@""]) {
            weather._1city = [weatherinfo valueForKey:@"city"];
            weather._2cityid = [weatherinfo valueForKey:@"cityid"];
            weather._3time = [weatherinfo valueForKey:@"time"];
            weather._4temp = [weatherinfo valueForKey:@"temp"];
            weather._5WD = [weatherinfo valueForKey:@"WD"];
            weather._6WS = [weatherinfo valueForKey:@"WS"];
            weather._7SD = [weatherinfo valueForKey:@"SD"];
        }
        weather._8date_y = [weatherinfo valueForKey:@"date_y"];
        weather._9week = [weatherinfo valueForKey:@"week"];
        weather._10temp1 = [weatherinfo valueForKey:@"temp1"];
        weather._11temp2 = [weatherinfo valueForKey:@"temp2"];
        weather._12temp3 = [weatherinfo valueForKey:@"temp3"];
        weather._13temp4 = [weatherinfo valueForKey:@"temp4"];
        weather._14temp5 = [weatherinfo valueForKey:@"temp5"];
        weather._15temp6 = [weatherinfo valueForKey:@"temp6"];
        weather._16weather1 = [weatherinfo valueForKey:@"weather1"];
        weather._17weather2 = [weatherinfo valueForKey:@"weather2"];
        weather._18weather3 = [weatherinfo valueForKey:@"weather3"];
        weather._19weather4 = [weatherinfo valueForKey:@"weather4"];
        weather._20weather5 = [weatherinfo valueForKey:@"weather5"];
        weather._21weather6 = [weatherinfo valueForKey:@"weather6"];
        weather._22img1 = [weatherinfo valueForKey:@"img1"];
        weather._23img3 = [weatherinfo valueForKey:@"img3"];
        weather._24img5 = [weatherinfo valueForKey:@"img5"];
        weather._25img7 = [weatherinfo valueForKey:@"img7"];
        weather._26img9 = [weatherinfo valueForKey:@"img9"];
        weather._27img11 = [weatherinfo valueForKey:@"img11"];
        weather._28wind1 = [weatherinfo valueForKey:@"wind1"];
        weather._29wind2 = [weatherinfo valueForKey:@"wind2"];
        weather._30wind3 = [weatherinfo valueForKey:@"wind3"];
        weather._31wind4 = [weatherinfo valueForKey:@"wind4"];
        weather._32wind5 = [weatherinfo valueForKey:@"wind5"];
        weather._33wind6 = [weatherinfo valueForKey:@"wind6"];
        weather._34fl1 = [weatherinfo valueForKey:@"fl1"];
        weather._35fl2 = [weatherinfo valueForKey:@"fl2"];
        weather._36fl3 = [weatherinfo valueForKey:@"fl3"];
        weather._37fl4 = [weatherinfo valueForKey:@"fl4"];
        weather._38fl5 = [weatherinfo valueForKey:@"fl5"];
        weather._39fl6 = [weatherinfo valueForKey:@"fl6"];
        weather._40index_d = [weatherinfo valueForKey:@"index_d"];
        weather._41index_uv = [weatherinfo valueForKey:@"index_uv"];
        weather._42index_xc = [weatherinfo valueForKey:@"index_xc"];
        weather._43index_tr = [weatherinfo valueForKey:@"index_tr"];
        weather._44index_co = [weatherinfo valueForKey:@"index_co"];
        weather._45index_cl = [weatherinfo valueForKey:@"index_cl"];
        weather._46index_ls = [weatherinfo valueForKey:@"index_ls"];
        weather._47index_ag = [weatherinfo valueForKey:@"index_ag"];
        
        NSDictionary *data = @{@"data":weather};
        
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)]){
            [self.delegate parser:self DidParsedData:data];
        }
    }
    return YES;
}


@end