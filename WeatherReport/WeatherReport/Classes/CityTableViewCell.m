//
//  CityTableViewCell.m
//  WeatherReport
//
//  Created by jerry on 13-5-17.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "CityTableViewCell.h"

@implementation CityTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //Initialization code
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = -5;
    frame.size.width = 330;
    [super setFrame:frame];
}

@end
