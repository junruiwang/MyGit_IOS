//
//  BillListController.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-26.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "OrderListParser.h"
#import "HotelOverviewParser.h"
#import "OderDetailParser.h"
#import "MySwitchView.h"
#import "JJEffectiveBillCell.h"
#import "Constants.h"

@interface BillListController : JJViewController<UITableViewDataSource, UITableViewDelegate, MySwitchViewDelegate, JJEffectiveBillCellDelegate>
{
@private
    BOOL isEctive;
}
@property (weak, nonatomic) IBOutlet MySwitchView *switchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *noOrderLabel;

@property(nonatomic, strong)HotelOverviewParser* hotelOverviewParser;
@property(nonatomic, strong)OrderListParser* orderListParser;
@property(nonatomic, strong)OderDetailParser* orderDetailParse;
@property(nonatomic, strong)NSMutableArray* billArray;
@property(nonatomic, strong)NSMutableArray* showArray;


//- (void)callPhone:(id)sender;

@end
