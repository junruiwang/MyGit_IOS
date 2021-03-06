//
//  BusLineViewController.h
//  OnlineBus
//
//  Created by jerry on 13-12-5.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//

#import "BannerViewController.h"


@interface BusLineViewController : BannerViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property(nonatomic, weak) IBOutlet UIView *topSearchView;
@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, weak) IBOutlet UITextField *queryField;

- (IBAction)searchButtonTapped:(id)sender;

@end
