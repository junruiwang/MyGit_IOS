//
//  JJOrderView.m
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-4-25.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "JJOrderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation JJOrderView


- (void)layoutSubviews
{//    const float priceR = 233.0f / 255.0f;
    //    const float priceG = 107.0f / 255.0f;
    //    const float priceB = 50.00f / 255.0f;
    [super layoutSubviews];
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithRed:233.0f / 255.0f green:233.0f / 255.0f blue:233.0f / 255.0 alpha:1.0].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(3, 3);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
