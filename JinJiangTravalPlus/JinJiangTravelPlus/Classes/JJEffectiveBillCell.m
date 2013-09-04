//
//  JJEffectiveBillCell.m
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-5-20.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "JJEffectiveBillCell.h"
#import "JJNavigationButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation JJEffectiveBillCell

@synthesize statusImg;
@synthesize contactLabel;
@synthesize hotelNameLabel;
@synthesize hotelPriceLabel;
@synthesize inDateLabel;
@synthesize outDateLabel;

const int BUTTON_TAG = 99;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellEditingStyleNone];
        
        //        UIImageView* backImage = [[UIImageView alloc] init];
        //        [backImage setFrame:CGRectMake(0, 2, JinJiangBillCellWidth, JinJiangBillCellHeight-3)];
        //        [backImage setImage:[UIImage imageNamed:@"order-list"]];
        //        [self addSubview:backImage];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, JinJiangBillCellWidth, JinJiangEffectiveBillCellHeight)];
        backView.layer.borderWidth = 1;
        backView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
        backView.layer.cornerRadius = 4.0;
        backView.layer.shadowOffset = CGSizeMake(0.0, 1);
        backView.layer.shadowColor = [UIColor whiteColor].CGColor;
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        self.hotelNameLabel = [[UILabel alloc] init];
        [self.hotelNameLabel setFrame:CGRectMake(23, 11, 238, 16)];
        [self.hotelNameLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.hotelNameLabel setBackgroundColor:[UIColor clearColor]];
        [self.hotelNameLabel setTextAlignment:UITextAlignmentLeft];
        [self.hotelNameLabel setTextColor:[UIColor blackColor]];
        [self.hotelNameLabel setText:@""];
        [self addSubview:self.hotelNameLabel];
        
        const unsigned int statusX = JinJiangBillCellWidth - StatusImgSize + 6;
        self.statusImg = [[UIImageView alloc] init];
        [self.statusImg setBackgroundColor:[UIColor clearColor]];
        [self.statusImg setFrame:CGRectMake(statusX, 2, StatusImgSize, StatusImgSize)];
        //[self.statusImg setImage:[UIImage imageNamed:@"已确认.png"]];
        [self addSubview:self.statusImg];
        
        const float conR = 149.0f / 255.0f;
        const float conG = 149.0f / 255.0f;
        const float conB = 149.0f / 255.0f;
        UILabel *addressLabelTitle = [[UILabel alloc] init];
        [addressLabelTitle setFrame:CGRectMake(23, 35, 80, 16)];
        [addressLabelTitle setFont:[UIFont systemFontOfSize:12]];
        [addressLabelTitle setBackgroundColor:[UIColor clearColor]];
        [addressLabelTitle setTextAlignment:UITextAlignmentLeft];
        [addressLabelTitle setTextColor:[UIColor colorWithRed:conR green:conG blue:conB alpha:1]];
        [addressLabelTitle setText:@"地  址："];
        [self addSubview:addressLabelTitle];
        
        self.addressLabel = [[UILabel alloc] init];
        [self.addressLabel setFrame:CGRectMake(70, 35, 180, 16)];
        [self.addressLabel setFont:[UIFont systemFontOfSize:12]];
        [self.addressLabel setBackgroundColor:[UIColor clearColor]];
        [self.addressLabel setTextAlignment:UITextAlignmentLeft];
        [self.addressLabel setTextColor:[UIColor colorWithRed:conR green:conG blue:conB alpha:1]];
        [self.addressLabel setText:@""];
        [self addSubview:self.addressLabel];
        
        UILabel* inLable1 = [[UILabel alloc] init];
        [inLable1 setFrame:CGRectMake(23, 58, 80, 16)];
        [inLable1 setFont:[UIFont systemFontOfSize:12]];
        [inLable1 setBackgroundColor:[UIColor clearColor]];
        [inLable1 setTextAlignment:UITextAlignmentLeft];
        [inLable1 setTextColor:[UIColor colorWithRed:conR green:conG blue:conB alpha:1]];
        [inLable1 setText:@"入住："];
        [self addSubview:inLable1];
        
        self.inDateLabel = [[UILabel alloc] init];
        [self.inDateLabel setFrame:CGRectMake(58, 58, 80, 16)];
        [self.inDateLabel setFont:[UIFont systemFontOfSize:12]];
        [self.inDateLabel setBackgroundColor:[UIColor clearColor]];
        [self.inDateLabel setTextAlignment:UITextAlignmentLeft];
        [self.inDateLabel setTextColor:[UIColor colorWithRed:conR green:conG blue:conB alpha:1]];
        [self.inDateLabel setText:@""];
        [self addSubview:self.inDateLabel];
        
        UILabel* outLable1 = [[UILabel alloc] init];
        [outLable1 setFrame:CGRectMake(132, 58, 80, 16)];
        [outLable1 setFont:[UIFont systemFontOfSize:12]];
        [outLable1 setBackgroundColor:[UIColor clearColor]];
        [outLable1 setTextAlignment:UITextAlignmentLeft];
        [outLable1 setTextColor:[UIColor colorWithRed:conR green:conG blue:conB alpha:1]];
        [outLable1 setText:@"退房："];
        [self addSubview:outLable1];
        
        self.outDateLabel = [[UILabel alloc] init];
        [self.outDateLabel setFrame:CGRectMake(167, 58, 80, 16)];
        [self.outDateLabel setFont:[UIFont systemFontOfSize:12]];
        [self.outDateLabel setBackgroundColor:[UIColor clearColor]];
        [self.outDateLabel setTextAlignment:UITextAlignmentLeft];
        [self.outDateLabel setTextColor:[UIColor colorWithRed:conR green:conG blue:conB alpha:1]];
        [self.outDateLabel setText:@""];
        [self addSubview:self.outDateLabel];
        
        
        UILabel* contactLabel1 = [[UILabel alloc] init];
        [contactLabel1 setFrame:CGRectMake(23, 81, 70, 16)];
        [contactLabel1 setFont:[UIFont systemFontOfSize:12]];
        [contactLabel1 setBackgroundColor:[UIColor clearColor]];
        [contactLabel1 setTextAlignment:UITextAlignmentLeft];
        [contactLabel1 setTextColor:[UIColor colorWithRed:conR green:conG blue:conB alpha:1]];
        [contactLabel1 setText:@"入住人："];
        [self addSubview:contactLabel1];
        
        self.contactLabel = [[UILabel alloc] init];
        [self.contactLabel setFrame:CGRectMake(80, 81, 145, 16)];
        [self.contactLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contactLabel setBackgroundColor:[UIColor clearColor]];
        [self.contactLabel setTextAlignment:UITextAlignmentLeft];
        [self.contactLabel setTextColor:[UIColor colorWithRed:conR green:conG blue:conB alpha:1]];
        [self.contactLabel setText:@""];
        [self addSubview:self.contactLabel];
        
        UIImageView *lineOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hotel-dashes.png"]];
        lineOne.frame = CGRectMake(9, 104, 302, 1);
        
        [self addSubview:lineOne];
        
        UILabel* priceLabel = [[UILabel alloc] init];
        [priceLabel setFrame:CGRectMake(23, 115, 80, 16)];
        [priceLabel setFont:[UIFont systemFontOfSize:12]];
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setTextAlignment:UITextAlignmentLeft];
        [priceLabel setTextColor:[UIColor colorWithRed:conR green:conG blue:conB alpha:1]];
        [priceLabel setText:@"总价："];
        [self addSubview:priceLabel];
        
        const float priceR = 235.0f / 255.0f;
        const float priceG = 97.0f / 255.0f;
        const float priceB = 0.00f;
        self.hotelPriceLabel = [[UILabel alloc] init];
        [self.hotelPriceLabel setFrame:CGRectMake(53, 114, 200, 20)];
        [self.hotelPriceLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [self.hotelPriceLabel setBackgroundColor:[UIColor clearColor]];
        [self.hotelPriceLabel setTextAlignment:UITextAlignmentLeft];
        [self.hotelPriceLabel setTextColor:[UIColor colorWithRed:priceR green:priceG blue:priceB alpha:1]];
        [self.hotelPriceLabel setText:@""];
        [self addSubview:self.hotelPriceLabel];
        
        
        
    }
    return self;
}

- (void)payButtonPressed:(id)sender
{
    [self.delegate clickToPay:self];
}

- (void)navigationButtonPressed:(JJNavigationButton *)sender
{
    [sender clickToNavigation:self.hotelInfo];
}

- (void)setIsPayButton:(BOOL)isPayButton
{
    UIView *button = [self viewWithTag:BUTTON_TAG];
    if (button) {
        [button removeFromSuperview];
    }
    if (isPayButton) {
        UIButton *orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        orderButton.tag = BUTTON_TAG;
        orderButton.frame = CGRectMake(250, 108, 55, 33);
        [orderButton setBackgroundImage:[UIImage imageNamed:@"btn_pay.png"] forState:UIControlStateNormal];
        [orderButton setBackgroundImage:[UIImage imageNamed:@"btn_pay_pressed.png"] forState:UIControlStateSelected];
        [orderButton addTarget:self action:@selector(payButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:orderButton];
    } else {
        JJNavigationButton *orderButton = [[JJNavigationButton alloc] initWithFrame:CGRectMake(194, 108, 111, 33)];
        orderButton.tag = BUTTON_TAG;
        [orderButton setBackgroundImage:[UIImage imageNamed:@"btn_bringToHotel.png"] forState:UIControlStateNormal];
        [orderButton setBackgroundImage:[UIImage imageNamed:@"btn_bringToHotel_pressed.png"] forState:UIControlStateSelected];
        [orderButton addTarget:self action:@selector(navigationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:orderButton];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

