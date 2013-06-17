//
//  LocalCalendarUtil.m
//  WeatherReport
//
//  Created by 汪君瑞 on 13-6-2.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "LocalCalendarUtil.h"

@implementation LocalCalendarUtil

+ (NSString *)getChineseCalendarWithDate:(NSDate *)date
{
    //定义农历数据:
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯", @"戊辰", @"己巳", @"庚午", @"辛未", @"壬申", @"癸酉",
                             @"甲戌", @"乙亥", @"丙子", @"丁丑", @"戊寅", @"己卯", @"庚辰", @"辛己", @"壬午", @"癸未",
                             @"甲申", @"乙酉", @"丙戌", @"丁亥", @"戊子", @"己丑", @"庚寅", @"辛卯", @"壬辰", @"癸巳",
                             @"甲午", @"乙未", @"丙申", @"丁酉", @"戊戌", @"己亥", @"庚子", @"辛丑", @"壬寅", @"癸丑",
                             @"甲辰", @"乙巳", @"丙午", @"丁未", @"戊申", @"己酉", @"庚戌", @"辛亥", @"壬子", @"癸丑",
                             @"甲寅", @"乙卯", @"丙辰", @"丁巳", @"戊午", @"己未", @"庚申", @"辛酉", @"壬戌", @"癸亥", nil];
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月",
                            @"七月", @"八月", @"九月", @"十月", @"冬月", @"腊月", nil];
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];

    return [NSString stringWithFormat: @"%@年%@%@",y_str,m_str,d_str];
}

+ (NSString *)getCurrentChineseWeekDay:(NSDate *)date
{
    const unsigned int weekday = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:date];
    NSString *cnWeek = @"";
    switch (weekday)
    {
        case 1:
        {   cnWeek = @"星期日"; break;  }
        case 2:
        {   cnWeek = @"星期一"; break;  }
        case 3:
        {   cnWeek = @"星期二"; break;  }
        case 4:
        {   cnWeek = @"星期三"; break;  }
        case 5:
        {   cnWeek = @"星期四"; break;  }
        case 6:
        {   cnWeek = @"星期五"; break;  }
        case 7:
        {   cnWeek = @"星期六"; break;  }
    }
    
    return cnWeek;
}

+ (NSString *)getCurrentChineseDay:(NSDate *)date
{
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dayComponents = [localeCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:date];
    return [NSString stringWithFormat:@"%d年%d月%d日",[dayComponents year],[dayComponents month],[dayComponents day]];
}

@end
