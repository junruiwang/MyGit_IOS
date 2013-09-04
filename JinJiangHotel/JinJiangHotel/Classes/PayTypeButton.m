//
//  PayTypeButton.m
//  JinJiangHotel
//
//  Created by jerry on 13-8-28.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "PayTypeButton.h"

@implementation PayTypeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 68, 21)];
        self.mainTitleLabel.textColor = RGBCOLOR(161, 127, 48);
        self.mainTitleLabel.font = [UIFont systemFontOfSize:12];
        self.mainTitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.mainTitleLabel];
        
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 207, 21)];
        self.subTitleLabel.textColor = RGBCOLOR(201, 201, 201);
        self.subTitleLabel.font = [UIFont systemFontOfSize:9];
        self.subTitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.subTitleLabel];
        
        self.selectedArrow = [[UIImageView alloc] initWithFrame:CGRectMake(205, 8, 30, 30)];
        self.selectedArrow.image = [UIImage imageNamed:@"check_arrow"];
        self.selectedArrow.hidden = YES;
        [self addSubview:self.selectedArrow];
    }
    return self;
}



@end
