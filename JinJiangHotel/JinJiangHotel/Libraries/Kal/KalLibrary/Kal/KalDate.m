/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalDate.h"
#import "KalPrivate.h"

static KalDate *today;

@implementation KalDate

+ (void)initialize
{
  today = [[KalDate dateFromNSDate:[NSDate date]] retain];
  // TODO set a timer for midnight to recache this value
}

+ (KalDate *)dateForDay:(unsigned int)day month:(unsigned int)month year:(unsigned int)year
{
  return [[[KalDate alloc] initForDay:day month:month year:year] autorelease];
}

+ (KalDate *)dateFromNSDate:(NSDate *)date
{
  NSDateComponents *parts = [date cc_componentsForMonthDayAndYear];
  return [KalDate dateForDay:[parts day] month:[parts month] year:[parts year]];
}

- (id)initForDay:(unsigned int)day month:(unsigned int)month year:(unsigned int)year
{
  if ((self = [super init])) {
    a.day = day;
    a.month = month;
    a.year = year;
  }
  return self;
}

- (unsigned int)day { return a.day; }
- (unsigned int)month { return a.month; }
- (unsigned int)year { return a.year; }

- (NSDate *)NSDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                              initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone localTimeZone]];
    [gregorian setLocale:[NSLocale currentLocale]];
//    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]]; // it will cause dead loop when timezone is 'NewYork'
    NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
    c.day = a.day;
    c.month = a.month;
    c.year = a.year;
    NSDate *date = [NSDate dateWithTimeInterval:0 sinceDate:[gregorian dateFromComponents:c]];
    [gregorian release];
    return date;
}

- (KalDate *)getPrecedingKalDate      //For selecting several tiles;
{
    NSDate *precedingDay = [[self NSDate] dateByAddingTimeInterval:-24*60*60];
    return [KalDate dateFromNSDate:precedingDay];
}

- (KalDate *)getNextKalDate      //For selecting several tiles;
{
    NSDate *nextDay = [[self NSDate] dateByAddingTimeInterval:24*60*60];
    
    return [KalDate dateFromNSDate:nextDay];
}

- (int)daysIntervalSinceDate:(KalDate *)otherDate
{
    return ([[self NSDate] timeIntervalSinceDate:[otherDate NSDate]] / (24 * 60 * 60));
}

- (BOOL)isToday { return [self isEqual:today]; }

- (NSComparisonResult)compare:(KalDate *)otherDate
{
  NSInteger selfComposite = a.year*10000 + a.month*100 + a.day;
  NSInteger otherComposite = [otherDate year]*10000 + [otherDate month]*100 + [otherDate day];
  
  if (selfComposite < otherComposite)
    return NSOrderedAscending;
  else if (selfComposite == otherComposite)
    return NSOrderedSame;
  else
    return NSOrderedDescending;
}

#pragma mark -
#pragma mark NSObject interface

- (BOOL)isEqual:(id)anObject
{
  if (![anObject isKindOfClass:[KalDate class]])
    return NO;
  
  KalDate *d = (KalDate*)anObject;
  return a.day == [d day] && a.month == [d month] && a.year == [d year];
}

- (NSUInteger)hash
{
  return a.day;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%02u/%02u/%u", a.month, a.day, a.year];
}

- (NSString *)chineseDescription
{
    return [NSString stringWithFormat:@"%u-%02u-%02u", a.year, a.month, a.day];
}

@end
