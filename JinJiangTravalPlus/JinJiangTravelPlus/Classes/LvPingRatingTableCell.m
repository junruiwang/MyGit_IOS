//
//  LvPingRatingTableCell.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-12.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "LvPingRatingTableCell.h"

@implementation LvPingRatingTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor redColor]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
