//
//  WeatherAWeekParser.m
//  WeatherReport
//
//  Created by 汪君瑞 on 13-6-1.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "WeatherAWeekParser.h"

@implementation WeatherAWeekParser

- (BOOL)parserJSONString:(NSString *)responseData
{
    if ([super parserJSONString:responseData]) {
        NSDictionary *dictionary = [responseData JSONValue];
        NSDictionary *weatherinfo = [dictionary valueForKey:@"weatherinfo"];
        ModelWeather *weather = [[ModelWeather alloc] init];
        
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
        weather._23img2 = [weatherinfo valueForKey:@"img2"];
        weather._24img3 = [weatherinfo valueForKey:@"img3"];
        weather._25img4 = [weatherinfo valueForKey:@"img4"];
        weather._26img5 = [weatherinfo valueForKey:@"img5"];
        weather._27img6 = [weatherinfo valueForKey:@"img6"];
        weather._28img7 = [weatherinfo valueForKey:@"img7"];
        weather._29img8 = [weatherinfo valueForKey:@"img8"];
        weather._30img9 = [weatherinfo valueForKey:@"img9"];
        weather._31img10 = [weatherinfo valueForKey:@"img10"];
        weather._32img11 = [weatherinfo valueForKey:@"img11"];
        weather._33img12 = [weatherinfo valueForKey:@"img12"];
        weather._34img_title1 = [weatherinfo valueForKey:@"img_title1"];
        weather._35img_title2 = [weatherinfo valueForKey:@"img_title2"];
        weather._36img_title3 = [weatherinfo valueForKey:@"img_title3"];
        weather._37img_title4 = [weatherinfo valueForKey:@"img_title4"];
        weather._38img_title5 = [weatherinfo valueForKey:@"img_title5"];
        weather._39img_title6 = [weatherinfo valueForKey:@"img_title6"];
        weather._40img_title7 = [weatherinfo valueForKey:@"img_title7"];
        weather._41img_title8 = [weatherinfo valueForKey:@"img_title8"];
        weather._42img_title9 = [weatherinfo valueForKey:@"img_title9"];
        weather._43img_title10 = [weatherinfo valueForKey:@"img_title10"];
        weather._44img_title11 = [weatherinfo valueForKey:@"img_title11"];
        weather._45img_title12 = [weatherinfo valueForKey:@"img_title12"];
        
        weather._46wind1 = [weatherinfo valueForKey:@"wind1"];
        weather._47wind2 = [weatherinfo valueForKey:@"wind2"];
        weather._48wind3 = [weatherinfo valueForKey:@"wind3"];
        weather._49wind4 = [weatherinfo valueForKey:@"wind4"];
        weather._50wind5 = [weatherinfo valueForKey:@"wind5"];
        weather._51wind6 = [weatherinfo valueForKey:@"wind6"];
        
        weather._52fl1 = [weatherinfo valueForKey:@"fl1"];
        weather._53fl2 = [weatherinfo valueForKey:@"fl2"];
        weather._54fl3 = [weatherinfo valueForKey:@"fl3"];
        weather._55fl4 = [weatherinfo valueForKey:@"fl4"];
        weather._56fl5 = [weatherinfo valueForKey:@"fl5"];
        weather._57fl6 = [weatherinfo valueForKey:@"fl6"];
        
        weather._58index = [weatherinfo valueForKey:@"index"];
        weather._59index_d = [weatherinfo valueForKey:@"index_d"];
        weather._60index48 = [weatherinfo valueForKey:@"index48"];
        weather._61index48_d = [weatherinfo valueForKey:@"index48_d"];
        weather._62index_uv = [weatherinfo valueForKey:@"index_uv"];
        weather._63index48_uv = [weatherinfo valueForKey:@"index48_uv"];
        weather._64index_xc = [weatherinfo valueForKey:@"index_xc"];
        weather._65index_tr = [weatherinfo valueForKey:@"index_tr"];
        weather._66index_co = [weatherinfo valueForKey:@"index_co"];
        weather._67index_cl = [weatherinfo valueForKey:@"index_cl"];
        weather._68index_ls = [weatherinfo valueForKey:@"index_ls"];
        weather._69index_ag = [weatherinfo valueForKey:@"index_ag"];
        
        NSDictionary *data = @{@"data":weather};
        
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)]){
            [self.delegate parser:self DidParsedData:data];
        }
    }
    return YES;
}

@end
