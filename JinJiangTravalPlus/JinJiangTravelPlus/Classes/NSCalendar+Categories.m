//
//  NSCalendar+Categories.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 4/27/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "NSCalendar+Categories.h"

@implementation NSCalendar (Categories)

-(NSInteger) daysFromDate:(NSDate *) startDate toDate:(NSDate *) endDate {
    
    NSCalendarUnit units=NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *comp1=[self components:units fromDate:startDate];
    NSDateComponents *comp2=[self components:units fromDate:endDate];
    
    [comp1 setHour:12];
    [comp2 setHour:12];
    
    NSDate *date1=[self dateFromComponents: comp1];
    NSDate *date2=[self dateFromComponents: comp2];
    
    return [[self components:NSDayCalendarUnit fromDate:date1 toDate:date2 options:0] day];
}

@end
