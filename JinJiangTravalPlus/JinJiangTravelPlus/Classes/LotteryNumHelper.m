//
//  LotteryNumHelper.m
//  JinJiangTravelPlus
//
//  Created by huguiqi on 07/01/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "LotteryNumHelper.h"

@implementation LotteryNumHelper

+(void)plusLotteryNum
{
     NSString *lotteryNumKey = [NSString stringWithFormat:@"lotteryNum%@%@", TheAppDelegate.userInfo.uid,TheAppDelegate.shakeAwardDate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger clientLotteryNum = [[self readCurrentLotteryNum] integerValue];
    NSMutableDictionary *dictionaryRead = [[defaults objectForKey:@"dayLotteryNum"] mutableCopy];
    
    if(!dictionaryRead){
        dictionaryRead = [NSMutableDictionary dictionary];
    }
    clientLotteryNum++;
    [dictionaryRead setValue:[NSString stringWithFormat:@"%i",clientLotteryNum ]  forKey:lotteryNumKey];
    
    [defaults setObject:dictionaryRead forKey:@"dayLotteryNum"];
}

+ (NSString *)readCurrentLotteryNum {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictionaryRead = [defaults objectForKey:@"dayLotteryNum"];
    NSInteger clientLotteryNum = 0;
    NSString *lotteryNumKey = [NSString stringWithFormat:@"lotteryNum%@%@", TheAppDelegate.userInfo.uid,TheAppDelegate.shakeAwardDate];
    if (dictionaryRead) {
        clientLotteryNum = [[dictionaryRead valueForKey:lotteryNumKey] integerValue];
    }
    return [NSString stringWithFormat:@"%i",clientLotteryNum];
 }

@end
