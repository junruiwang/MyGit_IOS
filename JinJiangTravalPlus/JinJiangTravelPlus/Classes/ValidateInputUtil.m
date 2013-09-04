//
//  ValidateInputUtil.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-21.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "ValidateInputUtil.h"

@implementation ValidateInputUtil

+ (BOOL)isEffectGuestNames:(NSString *)text guestCount:(NSInteger)guestCount
{
    NSArray *personNames = [text componentsSeparatedByString:@","];
    if (guestCount > personNames.count) {
        [self showAlertMessage:@"请填写真实入住人信息"];
        return NO;
    } else {
        for (int i = 0; i < personNames.count; i++) {
            NSString *personName = [personNames objectAtIndex:i];
            if (personName == nil || personName.length < 1) {
                [self showAlertMessage:@"请填写真实入住人信息"];
                return NO;
            }
            for (int j = 0; j < personNames.count; j++) {
                if (i == j) continue;
                NSString *personNameCompare = [personNames objectAtIndex:j];
                if ([personName isEqualToString:personNameCompare]) {
                    [self showAlertMessage:@"入住人信息不能重复"];
                    return NO;
                }
            }
        }
    }
    return YES;
}
+ (BOOL)isNotEmpty:(NSString *)text fieldCName:(NSString *)cName
{
    NSString *trimText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimText == nil || [trimText isEqualToString:@""])
    {   [self showAlertMessage: [NSString stringWithFormat:@"请输入%@", cName]];   return NO;  }
    return YES;
}

+ (BOOL)isEffectivePhone:(NSString *)text
{
    NSPredicate *predPhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^((13[0-9])|(147)|(15[0-9])|(18[0-9]))\\d{8}$"];
    if (![predPhone evaluateWithObject:text])
    {   [self showAlertMessage: NSLocalizedString(@"请输入11位手机号码", nil)]; return NO;  }
    return YES;
}

+ (BOOL)isEffectiveEmail:(NSString *)text
{
    NSPredicate *predEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"];
    if (![predEmail evaluateWithObject:text])
    {   [self showAlertMessage: NSLocalizedString(@"请输入正确的Email地址", nil)]; return NO;  }
    return YES;
}

+ (BOOL)isEffectivePassword:(NSString *)text
{
    NSPredicate *predPassword = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Za-z0-9]{6,17}"];
    if (![predPassword evaluateWithObject:text])
    {   [self showAlertMessage: NSLocalizedString(@"请输入6-20位的由字母和数字组成的密码", nil)];   return NO;  }
    return YES;
}


+ (BOOL)isPureInt:(NSString *) text
{
    NSScanner* scan = [NSScanner scannerWithString:text];
    int val;
    if(![scan scanInt:&val] && [scan isAtEnd])
    {
//      [NSString stringWithFormat:@"%@请输入数字", cName];
        [self showAlertMessage:@"请输入数字"];
        return NO;
    }
    return YES;
}

//+ (BOOL)isEmail: (NSString *) text {
//    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    if(![emailTest evaluateWithObject:text]){
//        [self showAlertMessage:@"请输入正确的邮箱"];
//        return NO;
//    }
//    return YES;
//}

+ (BOOL)isIdentifyNumber :(NSString *) text
{
    if (([text length] == 15 || [text length] == 18) && [self isPureInt:text])
    {   return YES; }
    else if ([text length] == 18 && [self isPureInt:[text substringToIndex:[text length] - 1]] &&
             ([[text substringFromIndex:[text length] - 1] caseInsensitiveCompare:@"X"] == NSOrderedSame))
    {   return YES; }
    else
    {   [self showAlertMessage:@"请输入正确的身份证号"];  return NO;  }
}

+ (BOOL)isCardNumber :(NSString *) text
{
    if ([text length] > 0 && [text isPureInt] == YES)
    {   return YES; }
    else
    {   [self showAlertMessage:@"银行卡号必须是数字，且不能为空"]; return NO;  }
}

+ (void)showAlertMessage:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"信息提示", nil)
                              message:msg
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                              otherButtonTitles:nil];
    [alertView show];
}

@end
