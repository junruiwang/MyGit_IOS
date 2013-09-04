//
//  HotelOverviewViewController.h
//  JinJiangTravelPlus
//
//  Created by Leon on 11/19/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelOverviewParser.h"
#import "JJViewController.h"

@interface HotelOverviewViewController : JJViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) int hotelId;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HotelOverviewParser *hotelOverviewParser;
@property (nonatomic, strong) NSMutableDictionary *hotelInfo;

@end
