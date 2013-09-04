//
//  IntegralRuleListParser.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-7-12.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "IntegralRuleListParser.h"
#import "GDataXMLNode.h"
#import "IntegralRule.h"

@implementation IntegralRuleListParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString])
    {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
        
        NSMutableArray *integralRuleList = [[NSMutableArray alloc] init];
        
        if ([rootElement elementsForName:@"exchangeCouponRuleDtos"].count > 0)
        {
            GDataXMLElement *rulesElement = [rootElement firstElementForName:@"exchangeCouponRuleDtos"];
            NSArray *ruleElementArray = [rulesElement elementsForName:@"exchangeCouponRuleDto"];
            
            for (GDataXMLElement *ruleElement in ruleElementArray)
            {
                IntegralRule *integralRule = [[IntegralRule alloc] init];
                integralRule.ruleId = [[ruleElement firstElementForName:@"id"] stringValue];
                integralRule.ruleName = [[ruleElement firstElementForName:@"ruleName"] stringValue];
                integralRule.description = [[ruleElement firstElementForName:@"description"] stringValue];
                integralRule.couponRuleType = [[ruleElement firstElementForName:@"couponRuleType"] stringValue];
                integralRule.couponTypeVal = [IntegralRule couponTypeFromAmount:[[ruleElement firstElementForName:@"couponParVale"] stringValue]];
                integralRule.cost = [[ruleElement firstElementForName:@"cost"] intValue];
                integralRule.effectDate = [self getStringDate:[[ruleElement firstElementForName:@"effectDate"] stringValue]];
                integralRule.invalidDate = [self getStringDate:[[ruleElement firstElementForName:@"invalidDate"] stringValue]];
                integralRule.mobileScoreGoodsId = [[ruleElement firstElementForName:@"mobileScoreGoodsId"] stringValue];
                
                [integralRuleList addObject:integralRule];
            }
            NSDictionary *data = @{@"integralRuleList":integralRuleList};
            
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
            {   [self.delegate parser:self DidParsedData:data]; }
        }
    }
    return YES;
}

- (NSString *)getStringDate:(NSString *) stringDate
{
    NSDateFormatter *tempformatter = [[NSDateFormatter alloc]init];
    [tempformatter setDateFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"];
    NSDate *date = [tempformatter dateFromString:stringDate];
    if (date) {
        NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dayComponents = [localeCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:date];
        return [NSString stringWithFormat:@"%d年%d月%d日",[dayComponents year],[dayComponents month],[dayComponents day]];
    }
    return @"";
}

@end
