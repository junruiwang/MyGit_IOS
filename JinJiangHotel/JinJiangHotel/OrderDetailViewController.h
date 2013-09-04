//
//  OrderDetailViewController.h
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-29.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "JJViewController.h"
#import "OrderDetail.h"
#import "OderDetailParser.h"
#import "HotelOverviewParser.h"

@interface OrderDetailViewController : JJViewController
{
@private
    OrderDetail* order;
}

@property(nonatomic, strong)OderDetailParser* oderDetailParser;
@property(nonatomic, strong)HotelOverviewParser* hotelOverviewParser;

@property(nonatomic, strong)NSString* orderNo;
@property(nonatomic, strong)NSString* orderId;
@property(nonatomic, strong)NSString* hotelName;
@property(nonatomic) OrderStatus status;
@property (nonatomic, strong) OrderDetail *orderDetail;

@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderAmountInPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payedLabel;
@property (weak, nonatomic) IBOutlet UILabel *payedAmountInPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *livingCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotelNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *roomStyleLabel;
@property (weak, nonatomic) IBOutlet UILabel *arriveTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *livingPersonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumberLabel;
@property (weak, nonatomic) IBOutlet UITextView *cancelPolicyTextView;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;

@end
