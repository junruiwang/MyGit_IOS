//
//  PromotionViewController.h
//  JinJiangHotel
//
//  Created by Rong Hao on 13-9-2.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "JJViewController.h"
#import "PromotionsParser.h"
#import "PromotionCell.h"

@interface PromotionViewController : JJViewController <UITableViewDataSource, UITableViewDelegate, PromotionCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *promitionTable;

@property(nonatomic, strong)PromotionsParser* promotionsParser;
@property(nonatomic, strong)NSMutableArray* promotionArray;

@end
