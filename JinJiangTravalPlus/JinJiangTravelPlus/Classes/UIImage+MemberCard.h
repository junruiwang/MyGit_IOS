//
//  UIImage+MemberCard.h
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-3-27.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MemberCard)

- (UIImage*) drawCardNum:(NSString*) cardNum memberName:(NSString *)userName valiDate:(NSString *)valiDate withType:(NSString *)cardType;
- (UIImage *) drawMemberRight:(NSDictionary *) data withType:(NSString *)cardType;
- (UIImage *)addPassBookButton:(NSString *)passBookBtnImage;
@end
