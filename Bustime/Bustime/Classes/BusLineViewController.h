//
//  BusLineViewController.h
//  Bustime
//
//  Created by 汪君瑞 on 13-3-31.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import "BannerViewController.h"
#import "BusLineParser.h"

@interface BusLineViewController : BannerViewController<UITableViewDataSource, UITableViewDelegate, GDataParserDelegate>


@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, weak) IBOutlet UITextField *queryField;
@property (nonatomic, strong) NSMutableArray *busLineArray;
@property (nonatomic, strong) BusLineParser *busLineParser;

- (IBAction)searchButtonTapped:(id)sender;

@end
