//
//  OrderListCell.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-29.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "OrderListCell.h"
#import "JJNavigationButton.h"

const int BUTTON_TAG = 99;

@implementation OrderListCell

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
        orderButton.frame = CGRectMake(196, 113, 110, 30);
        [orderButton setBackgroundImage:[UIImage imageNamed:@"order_pay.png"] forState:UIControlStateNormal];
        [orderButton addTarget:self action:@selector(payButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:orderButton];
    } else {
        JJNavigationButton *orderButton = [[JJNavigationButton alloc] initWithFrame:CGRectMake(196, 113, 110, 30)];
        orderButton.tag = BUTTON_TAG;
        [orderButton setBackgroundImage:[UIImage imageNamed:@"order_navigation.png"] forState:UIControlStateNormal];
        [orderButton addTarget:self action:@selector(navigationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:orderButton];
    }
    
}


@end
