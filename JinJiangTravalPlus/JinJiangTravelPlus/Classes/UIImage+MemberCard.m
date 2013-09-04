//
//  UIImage+MemberCard.m
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-3-27.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "UIImage+MemberCard.h"

@implementation UIImage (MemberCard)

- (UIImage *) drawMemberRight:(NSDictionary *) data withType:(NSString *)cardType
{
    UIImage *back = [UIImage imageNamed:@"btn_flip_back.png"];
    CGRect buttonRect = CGRectMake(46, 72, 60, 60);
    NSString *detail = @"";
    NSArray *array = [data objectForKey:@"memberCardRights"];
    for (NSDictionary *dict in array) {
        NSString *tempString = [dict objectForKey:@"type"];
        if ([cardType isEqualToString:tempString]) {
            detail = [dict objectForKey:@"detail"];
        }
    }
    
    UIColor *detailColor =
    [cardType isEqualToString:JBENEFITCARD] ? [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:221.0/255.0 alpha:1] :
    [cardType isEqualToString:J2BENEFITCARD] ? [UIColor colorWithRed:197.0/255.0 green:168.0/255.0 blue:111.0/255.0 alpha:1] :
    [cardType isEqualToString:J8BENEFITCARD] ? [UIColor colorWithRed:181.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] :
    [cardType isEqualToString:(JJCARD)] ? [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:221.0/255.0 alpha:1] : [UIColor grayColor];
    
    //定义各文字字体大小
    UIFont *fontDetail = [UIFont boldSystemFontOfSize:30];
    
    
    CGPoint cardDetailPosition = CGPointMake(94, 332);
    
    //    if ([cardType isEqualToString:(JJCARD)]) //classic
    //    {
    //        //礼卡 元素定位
    //        cardWordPosition = CGPointMake(768 - (userName.length -2) * 42, 438);
    //        cardNumPosition = CGPointMake(584, 496);
    //        cardDatePosition = CGPointZero;
    //    }
    
    UIGraphicsBeginImageContext(CGSizeMake(920, 640));
    [self drawInRect:CGRectMake(0,0,920, 640)];
    [back drawInRect:buttonRect];
    CGRect rectDetail = CGRectMake(cardDetailPosition.x, cardDetailPosition.y, self.size.width, self.size.height);
    
    [detailColor set];
    [detail drawInRect:CGRectIntegral(rectDetail) withFont:fontDetail];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}



- (UIImage*) drawCardNum:(NSString*) cardNum memberName:(NSString *)userName valiDate:(NSString *)valiDate withType:(NSString *)cardType
{
    UIImage *info = [UIImage imageNamed:@"btn_flip_info.png"];
    CGRect buttonRect = CGRectMake(46, 72, 60, 60);
    
    //会员卡号码添加空格
    cardNum = [self addSpaceInCardNumber:cardNum];
    
    //定义各文字字体大小
    UIFont *fontWord = [UIFont boldSystemFontOfSize:42];
    UIFont *fontNum = [UIFont boldSystemFontOfSize:44];
    UIFont *fontDate = [UIFont boldSystemFontOfSize:36];
    
    
    //享卡 元素定位
    CGPoint cardWordPosition = CGPointMake(98, 420);
    CGPoint cardNumPosition = CGPointMake(98, 478);
    CGPoint cardDatePosition = CGPointMake(258, 528);
    
    if ([cardType isEqualToString:(JJCARD)]) //classic
    {
        //礼卡 元素定位
        cardWordPosition = CGPointMake(768 - (userName.length -2) * 42, 438);
        cardNumPosition = CGPointMake(584, 496);
        cardDatePosition = CGPointZero;
    }
    
    
    UIGraphicsBeginImageContext(CGSizeMake(920, 640));
    [self drawInRect:CGRectMake(0,0,920, 640)];
    [info drawInRect:buttonRect];
    CGRect rectNum = CGRectMake(cardNumPosition.x, cardNumPosition.y, self.size.width, self.size.height);
    CGRect rectName = CGRectMake(cardWordPosition.x, cardWordPosition.y, self.size.width, self.size.height);
    CGRect rectDate = CGRectMake(cardDatePosition.x, cardDatePosition.y, self.size.width, self.size.height);
    
    CGRect rectNumShadow = CGRectMake(cardNumPosition.x+3, cardNumPosition.y+3, self.size.width, self.size.height);
    CGRect rectNameShadow = CGRectMake(cardWordPosition.x+3, cardWordPosition.y + 3, self.size.width, self.size.height);
    CGRect rectDateShadow = CGRectMake(cardDatePosition.x+3, cardDatePosition.y + 3, self.size.width, self.size.height);
    
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] set];
    [cardNum drawInRect:CGRectIntegral(rectNumShadow) withFont:fontNum];
    [userName drawInRect:CGRectIntegral(rectNameShadow) withFont:fontWord];
    if (cardDatePosition.x > 0 && valiDate != NULL) {
        [valiDate drawInRect:CGRectIntegral(rectDateShadow) withFont:fontDate];
    }
    
    
    [[UIColor whiteColor] set];
    [cardNum drawInRect:CGRectIntegral(rectNum) withFont:fontNum];
    [userName drawInRect:CGRectIntegral(rectName) withFont:fontWord];
    
    if (cardDatePosition.x > 0) {
        [valiDate drawInRect:CGRectIntegral(rectDate) withFont:fontDate];
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSString *)addSpaceInCardNumber:(NSString *)oriCardNum
{
    NSString *first = [oriCardNum substringToIndex:4];
    NSString *second = [oriCardNum substringWithRange:NSMakeRange(4, 4)];
    NSString *third = [oriCardNum substringFromIndex:8];
    
    return [NSString stringWithFormat:@"%@ %@ %@", first, second, third];
    
}

- (UIImage *)addPassBookButton:(NSString *)passBookBtnImage
{
    UIImage *passBookButtonImage = [UIImage imageNamed:passBookBtnImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(920, 640));
    [self drawInRect:CGRectMake(0,0,920, 640)];
    [passBookButtonImage drawInRect:CGRectMake(320, 72, 230, 40)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
