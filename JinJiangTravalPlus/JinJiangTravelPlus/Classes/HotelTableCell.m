//
//  HotelTableCell.m
//  
//
//  Created by Li Peng on 10-8-24.
//  Copyright 2010 JinJiang. All rights reserved.
//

#import "HotelTableCell.h"

#pragma mark - HotelTableCell

@implementation HotelTableCell

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = -5;
    frame.size.width = 330;
    [super setFrame:frame];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) != nil) {
        const float priceR = 233.0f / 255.0f;
        const float priceG = 107.0f / 255.0f;
        const float priceB = 50.00f / 255.0f;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(103, 6, 210, 20)];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.nameLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self.nameLabel setTextAlignment:UITextAlignmentLeft];
        [self.nameLabel setTextColor:[UIColor blackColor]];
        [self addSubview:self.nameLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(212, 29, 69, 32)];
        [self.priceLabel setBackgroundColor:[UIColor clearColor]];
        [self.priceLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [self.priceLabel setTextAlignment:UITextAlignmentRight];
        [self.priceLabel setTextColor:[UIColor colorWithRed:priceR green:priceG blue:priceB alpha:1]];
        [self addSubview:self.priceLabel];
        
        self.areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(106, 53, 127, 21)];
        [self.areaLabel setBackgroundColor:[UIColor clearColor]];
        [self.areaLabel setFont:[UIFont systemFontOfSize:14]];
        self.areaLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:self.areaLabel];
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 8, 80, 60)];
        [self.iconView setBackgroundColor:[UIColor clearColor]];[self addSubview:self.iconView];
        
        const float r = 59.0f/255.0f, g = 139.0f/255.0f, b = 198.0f/255.0f;
        self.fenLabel = [[UILabel alloc] initWithFrame:CGRectMake(133, 31, 17, 21)];
        [self.fenLabel setTextAlignment:UITextAlignmentLeft];
        [self.fenLabel setTextColor:[UIColor colorWithRed:r green:g blue:b alpha:1]];
        [self.fenLabel setBackgroundColor:[UIColor clearColor]];
        [self.fenLabel setFont:[UIFont systemFontOfSize:14]];
        [self.fenLabel setText:@"分"];[self addSubview:self.fenLabel];
        
        self.hotelRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(106, 31, 26, 22)];
        [self.hotelRateLabel setTextAlignment:UITextAlignmentLeft];
        [self.hotelRateLabel setTextColor:[UIColor colorWithRed:r green:g blue:b alpha:1]];
        [self.hotelRateLabel setBackgroundColor:[UIColor clearColor]];
        [self.hotelRateLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [self.hotelRateLabel setText:@""];[self addSubview:self.hotelRateLabel];
        
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(162, 32, 53, 20)];
        [self.distanceLabel setTextAlignment:UITextAlignmentRight];
        [self.distanceLabel setTextColor:[UIColor darkGrayColor]];
        [self.distanceLabel setBackgroundColor:[UIColor clearColor]];
        [self.distanceLabel setFont:[UIFont systemFontOfSize:12]];
        [self.distanceLabel setText:@"分"];[self addSubview:self.distanceLabel];
        
        self.upLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 34, 12, 15)];
        [self.upLabel setTextAlignment:UITextAlignmentLeft];
        [self.upLabel setTextColor:[UIColor darkGrayColor]];
        [self.upLabel setBackgroundColor:[UIColor clearColor]];
        [self.upLabel setFont:[UIFont systemFontOfSize:12]];
        [self.upLabel setText:@"起"];[self addSubview:self.upLabel];
        
        self.dollarLabel = [[UILabel alloc] initWithFrame:CGRectMake(192, 32, 8, 18)];
        [self.dollarLabel setTextAlignment:UITextAlignmentLeft];
        [self.dollarLabel setTextColor:[UIColor colorWithRed:priceR green:priceG blue:priceB alpha:1]];
        [self.dollarLabel setBackgroundColor:[UIColor clearColor]];
        [self.dollarLabel setFont:[UIFont systemFontOfSize:12]];
        [self.dollarLabel setText:@"￥"];[self addSubview:self.dollarLabel];
        
        self.starView = [[JJStarView alloc] initWithFrame:CGRectMake(249, 60, 66, 9)];
        [self.starView setBackgroundColor:[UIColor clearColor]];[self addSubview:self.starView];
        
        self.soldoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(241, 31, 51, 21)];
        [self.soldoutLabel setTextAlignment:UITextAlignmentLeft];
        [self.soldoutLabel setTextColor:[UIColor darkGrayColor]];
        [self.soldoutLabel setBackgroundColor:[UIColor clearColor]];
        [self.soldoutLabel setFont:[UIFont systemFontOfSize:17]];
        [self.soldoutLabel setText:@"已售完"];[self addSubview:self.soldoutLabel];
        
        UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hotel-next.png"]];
        [img setFrame:CGRectMake(300, 34, 7, 10)];[self addSubview:img];
    }
    return self;
}

@end


#pragma mark - HotelDetailTableCell

@implementation HotelDetailTableCell

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

