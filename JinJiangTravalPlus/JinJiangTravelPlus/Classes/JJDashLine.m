//
//  JJDashLine.m
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-4-26.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "JJDashLine.h"

@implementation JJDashLine


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    UIImageView *lineOne = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 250, 1)];
    lineOne.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"dashed.png"]
                                                              stretchableImageWithLeftCapWidth:20 topCapHeight:0]];
    [self addSubview:lineOne];
    
    
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
