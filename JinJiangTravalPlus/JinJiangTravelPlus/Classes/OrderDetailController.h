//
//  OrderDetailController.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-26.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Constants.h"
#import "JJViewController.h"
#import "OderDetailParser.h"
#import "HotelOverviewParser.h"
#import "OrderCancelView.h"
#import "HotelOrder.h"
#import "OderDetail.h"
#import "OrderPassbookViewController.h"
#import "JJNavigationButton.h"
#import "OrderPassbookForm.h"


@interface OrderDetailController : JJViewController<GDataXMLParserDelegate, OrderCancelViewDelegate, UIActionSheetDelegate>
{
@private
    OderDetail* order;
}

@property(nonatomic, strong)OderDetailParser* oderDetailParser;
@property(nonatomic, strong)HotelOverviewParser* hotelOverviewParser;
@property(nonatomic, strong)NSString* orderNo;
@property(nonatomic, strong)NSString* orderId;
@property(nonatomic, strong)NSString* hotelName;


@property(nonatomic, strong)UIImageView* statusImg;
@property(nonatomic, strong)UILabel* guaranteePolicyDesc;

@property(nonatomic, strong)UIButton* cancelBtn;
@property(nonatomic, strong)UIImageView* coverImage;
@property(nonatomic, strong)OrderCancelView* cancelView;
@property(nonatomic, strong)OderDetail* orderDetail;
@property(nonatomic)OrderStatus status;

@property(nonatomic,weak)IBOutlet UIButton *passbookBtn;
@property(nonatomic,strong)OrderPassbookViewController *showPassbookController;

@property(nonatomic,strong) OrderPassbookForm *passbookForm;


@property (nonatomic, strong) NSString *payFeedBackDesc;
@property (nonatomic) BOOL isInActivity;
@end
