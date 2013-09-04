//
//  CouponListViewController.h
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-22.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "JJViewController.h"
#import "GAITrackedViewController.h"

@interface CouponListViewController : GAITrackedViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray* couponArray;
@property (nonatomic, retain) IBOutlet UITableView* tableView;

@end
