//
//  FaverateCell.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 13-1-16.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "FaverateCell.h"

@implementation FaverateCell

@synthesize hotelID;
@synthesize brandImg, img;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellEditingStyleNone];

        self.brandImg = [[UIImageView alloc] initWithFrame:CGRectMake(38, 10, 20, 20)];
        [self.brandImg setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.brandImg];

        self.img = [[UIImageView alloc] initWithFrame:CGRectMake(249, 15, 7, 10)];
        [self.img setBackgroundColor:[UIColor clearColor]];
        [self.img setImage:[UIImage imageNamed:@"hotel-next.png"]];
        [self addSubview:self.img];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
