//
//  MoreViewController.h
//  OnlineBus
//
//  Created by jerry on 13-12-7.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//

#import "BannerViewController.h"

@interface MoreViewController : BannerViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UITableView *tableView;

@end
