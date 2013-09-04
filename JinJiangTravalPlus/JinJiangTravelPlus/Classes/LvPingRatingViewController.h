//
//  LvPingRatingViewController.h
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-12.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "JJViewController.h"
#import "LvPingHotelRating.h"
#import "WebViewController.h"

@interface LvPingRatingViewController : JJViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LvPingHotelRating *lvPingHotelRating;
@property (nonatomic, strong) WebViewController *webViewController;

@end
