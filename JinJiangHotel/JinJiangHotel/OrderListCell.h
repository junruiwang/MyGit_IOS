//
//  OrderListCell.h
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-29.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJHotel.h"

@class OrderListCell;
@protocol OrderListCellDelegate <NSObject>

- (void)clickToPay:(OrderListCell *)sender;

@end

@interface OrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property(nonatomic) BOOL isPayButton;
@property(nonatomic, strong)NSString* orderNo;
@property (weak, nonatomic) IBOutlet UIButton *buttonInCell;

@property(nonatomic, strong)JJHotel *hotelInfo;

@property(nonatomic, weak)id<OrderListCellDelegate> delegate;

@end
