//
//  IntegralRuleListViewController.h
//  JinJiangTravelPlus
//
//  Created by jerry on 13-7-10.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "JJViewController.h"
#import "IntegralRuleListParser.h"
#import "IntegralRuleTableCell.h"

@interface IntegralRuleListViewController : JJViewController<UITableViewDataSource, UITableViewDelegate, IntegralRuleCellDelegate>

@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *integralRuleArray;
@property (nonatomic, strong) IntegralRuleListParser *integralRuleListParser;

@end
