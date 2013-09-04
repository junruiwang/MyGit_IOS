//
//  PromotionCell.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-9-2.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "PromotionCell.h"

@implementation PromotionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)shareButtonPressed:(UIButton *)sender {
    [self.delegate shareButtonClick:self];
}

@end
