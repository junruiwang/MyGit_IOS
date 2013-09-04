//
//  CouponTableCell.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-1-5.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "CouponTableCell.h"

@implementation CouponTableCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellEditingStyleNone];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
