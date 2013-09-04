//
//  OrderListViewController.h
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-29.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "JJViewController.h"
#import "MySwitchView.h"
#import "HotelOverviewParser.h"
#import "OrderListParser.h"
#import "OderDetailParser.h"
#import "LoginViewController.h"
#import "Constants.h"
#import "OrderListCell.h"

@interface OrderListViewController : JJViewController <UITableViewDataSource, UITableViewDelegate, MySwitchViewDelegate, OrderListCellDelegate>
{
@private
    BOOL isEctive;
}
@property (weak, nonatomic) IBOutlet UILabel *effectiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;

@property (weak, nonatomic) IBOutlet MySwitchView *switchView;
@property (weak, nonatomic) IBOutlet UITableView *orderListTable;
@property (weak, nonatomic) IBOutlet UITextView *noOrderLabel;
@property (nonatomic, strong) UILabel *threeMonthsInfoLabel;

@property(nonatomic, strong)HotelOverviewParser* hotelOverviewParser;
@property(nonatomic, strong)OrderListParser* orderListParser;
@property(nonatomic, strong)OderDetailParser* orderDetailParse;
@property(nonatomic, strong)NSMutableArray* billArray;
@property(nonatomic, strong)NSMutableArray* showArray;



@end
