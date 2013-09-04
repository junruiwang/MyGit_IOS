//
//  NSString+Categories.m
//  JinJiangTravalPlus
//
//  Created by Leon on 10/29/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#import "NSString+Categories.h"

@implementation NSString (Categories)

- (NSString *)URLEncodedString
{
    NSString *result = CFBridgingRelease(
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            CFSTR("!*'();:@&amp;=+$,/?%#[] "),
                                            kCFStringEncodingUTF8));
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = CFBridgingRelease(
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                            (CFStringRef)self,
                                                            CFSTR(""),
                                                            kCFStringEncodingUTF8));
    return result;
}

- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isPhoneNumber
{
    if ([self hasPrefix:@"1"] && [self length] == 11 && [self isPureInt] == YES)
    {   return YES; }
    else
    {   return NO;  }
}

- (BOOL)isCardNumber
{
    if ([self length] > 0 && [self isPureInt] == YES)
    {   return YES; }
    else
    {   return NO;  }
}

- (BOOL)isIdentifyNumber
{
    if (([self length] == 15 || [self length] == 18) && [self isPureInt])
    {   return YES; }
    else if ([self length] == 18 && [[self substringToIndex:[self length] - 1] isPureInt] &&
             ([[self substringFromIndex:[self length] - 1] caseInsensitiveCompare:@"X"] == NSOrderedSame))
    {   return YES; }
    else
    {   return NO;  }
}


-(BOOL)isBlank
{
    return [@"" isEqualToString:self];
}

- (NSString *)nilStringFlagJudge
{
    if ([self isEqualToString:nil] || [self isEqualToString:@""])  // convert @"nil" to nil
    {   return nil; }
    else
    {   return self;}
}

- (NSString *)removeSpace
{
    NSMutableString *mutableStr = [NSMutableString stringWithString:self];
    [mutableStr replaceOccurrencesOfString:@" "
                                withString:@""
                                   options:0
                                     range:NSMakeRange(0, [mutableStr length])];
    return mutableStr;
}

- (NSString*)sortedQueryString
{
    NSArray* array = [self componentsSeparatedByString:@"&"];
    array = [array sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString* string = [NSString string];
    for(NSString* str in array)
    {
        string = [string stringByAppendingFormat:@"%@&", str];
    }
    string = [string substringToIndex:[string length] - 1];

    return string;
}

-(NSString*)trim
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:whitespace];
}


@end
