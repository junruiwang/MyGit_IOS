//
//  JinJiangBillCell.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-26.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "JinJiangBillCell.h"

@implementation JinJiangBillCell

@synthesize statusImg;
@synthesize contactLabel;
@synthesize hotelNameLabel;
@synthesize hotelPriceLabel;
@synthesize inDateLabel;
@synthesize outDateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellEditingStyleNone];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, JinJiangBillCellWidth, JinJiangBillCellHeight)];
        backView.layer.borderWidth = 1;
        backView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
        backView.layer.cornerRadius = 4.0;
        backView.layer.shadowOffset = CGSizeMake(0.0, 0.5);
        backView.layer.shadowColor = [UIColor whiteColor].CGColor;
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];

        const unsigned int statusX = JinJiangBillCellWidth - StatusImgSize + 6;
        self.statusImg = [[UIImageView alloc] init];
        [self.statusImg setBackgroundColor:[UIColor clearColor]];
        [self.statusImg setFrame:CGRectMake(statusX, 2, StatusImgSize, StatusImgSize)];
        //[self.statusImg setImage:[UIImage imageNamed:@"已确认.png"]];
        [self addSubview:self.statusImg];

        const float priceR = 235.0f / 255.0f;
        const float priceG = 97.0f / 255.0f;
        const float priceB = 0.0f;
        self.hotelPriceLabel = [[UILabel alloc] init];
        [self.hotelPriceLabel setFrame:CGRectMake(195, 50, 85, 18)];
        [self.hotelPriceLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self.hotelPriceLabel setBackgroundColor:[UIColor clearColor]];
        [self.hotelPriceLabel setTextAlignment:UITextAlignmentRight];
        [self.hotelPriceLabel setTextColor:[UIColor colorWithRed:priceR green:priceG blue:priceB alpha:1]];
        [self.hotelPriceLabel setText:@""];
        [self addSubview:self.hotelPriceLabel];

        UIImageView* arrow1 = [[UIImageView alloc] init];
        [arrow1 setFrame:CGRectMake(280, 50, 18, 18)];
        [arrow1 setImage:[UIImage imageNamed:@"arrow1.png"]];
        [self addSubview:arrow1];

        self.hotelNameLabel = [[UILabel alloc] init];
        [self.hotelNameLabel setFrame:CGRectMake(20, 11, 238, 16)];
        [self.hotelNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.hotelNameLabel setBackgroundColor:[UIColor clearColor]];
        [self.hotelNameLabel setTextAlignment:UITextAlignmentLeft];
        [self.hotelNameLabel setTextColor:[UIColor blackColor]];
        [self.hotelNameLabel setText:@""];
        [self addSubview:self.hotelNameLabel];

        UILabel* contactLabel1 = [[UILabel alloc] init];
        [contactLabel1 setFrame:CGRectMake(14+9, 53, 180, 16)];
        [contactLabel1 setFont:[UIFont systemFontOfSize:14]];
        [contactLabel1 setBackgroundColor:[UIColor clearColor]];
        [contactLabel1 setTextAlignment:UITextAlignmentLeft];
        [contactLabel1 setTextColor:[UIColor lightGrayColor]];
        [contactLabel1 setText:@"入住人："];
        [self addSubview:contactLabel1];

        self.contactLabel = [[UILabel alloc] init];
        [self.contactLabel setFrame:CGRectMake(80, 53, 145, 16)];
        [self.contactLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contactLabel setBackgroundColor:[UIColor clearColor]];
        [self.contactLabel setTextAlignment:UITextAlignmentLeft];
        [self.contactLabel setTextColor:[UIColor lightGrayColor]];
        [self.contactLabel setText:@""];
        [self addSubview:self.contactLabel];

//        const float inR = 101.0f / 255.0f;
//        const float inG = 101.0f / 255.0f;
//        const float inB = 101.0f / 255.0f;
        UILabel* inLable1 = [[UILabel alloc] init];
        [inLable1 setFrame:CGRectMake(14+9, 33, 80, 16)];
        [inLable1 setFont:[UIFont systemFontOfSize:12]];
        [inLable1 setBackgroundColor:[UIColor clearColor]];
        [inLable1 setTextAlignment:UITextAlignmentLeft];
        [inLable1 setTextColor:[UIColor lightGrayColor]];
        [inLable1 setText:@"入住："];
        [self addSubview:inLable1];

        self.inDateLabel = [[UILabel alloc] init];
        [self.inDateLabel setFrame:CGRectMake(49+9, 33, 80, 16)];
        [self.inDateLabel setFont:[UIFont systemFontOfSize:12]];
        [self.inDateLabel setBackgroundColor:[UIColor clearColor]];
        [self.inDateLabel setTextAlignment:UITextAlignmentLeft];
        [self.inDateLabel setTextColor:[UIColor lightGrayColor]];
        [self.inDateLabel setText:@"12-25"];
        [self.inDateLabel setText:@""];
        [self addSubview:self.inDateLabel];

        UILabel* outLable1 = [[UILabel alloc] init];
        [outLable1 setFrame:CGRectMake(123+9, 33, 80, 16)];
        [outLable1 setFont:[UIFont systemFontOfSize:12]];
        [outLable1 setBackgroundColor:[UIColor clearColor]];
        [outLable1 setTextAlignment:UITextAlignmentLeft];
        [outLable1 setTextColor:[UIColor lightGrayColor]];
        [outLable1 setText:@"退房："];
        [self addSubview:outLable1];

        self.outDateLabel = [[UILabel alloc] init];
        [self.outDateLabel setFrame:CGRectMake(158+9, 33, 80, 16)];
        [self.outDateLabel setFont:[UIFont systemFontOfSize:12]];
        [self.outDateLabel setBackgroundColor:[UIColor clearColor]];
        [self.outDateLabel setTextAlignment:UITextAlignmentLeft];
        [self.outDateLabel setTextColor:[UIColor lightGrayColor]];
        [self.outDateLabel setText:@"12-26"];
        [self.outDateLabel setText:@""];
        [self addSubview:self.outDateLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
