//
//  PointsHostoryListViewController.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 7/15/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJViewController.h"

@interface PointsHistoryListViewController : JJViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,weak) IBOutlet UIView *bgView;

@property(nonatomic,weak) IBOutlet UIView *headView;

@property(nonatomic,weak) IBOutlet UIView *historyListView;

@property(nonatomic,weak) IBOutlet UITableView *tableView;

@property(nonatomic,weak) IBOutlet UILabel *fullNameLabel;

@property(nonatomic,weak) IBOutlet UILabel *cardNoLabel;

@property(nonatomic,weak) IBOutlet UILabel *remainPointsLabel;

@property(nonatomic,strong) NSMutableArray *historyList;





@end
