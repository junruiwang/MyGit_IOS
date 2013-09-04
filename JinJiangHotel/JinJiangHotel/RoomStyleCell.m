//
//  RoomStyleCell.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-21.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "RoomStyleCell.h"

@implementation RoomStyleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //cell背景色
        self.backgroundColor = [UIColor clearColor];
        //下降阴影
        self.dropsShadow = NO;
        //圆弧
        self.cornerRadius = 4;
        //选中行背景色
        self.selectionGradientStartColor = RGBCOLOR(231, 231, 231);
        self.selectionGradientEndColor = RGBCOLOR(231, 231, 231);
        
        //cell之间的分割线
        self.customSeparatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
    }
    return self;
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
