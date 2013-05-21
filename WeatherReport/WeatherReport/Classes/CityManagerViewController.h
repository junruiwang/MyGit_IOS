//
//  CityManagerViewController.h
//  WeatherReport
//
//  Created by jerry on 13-5-17.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "BannerViewController.h"
#import "LocalCityListManager.h"
#import "CityTableListViewController.h"

@protocol CityManagerControllerDelegate <NSObject>

@optional
- (void)citySelected;
@end

@interface CityManagerViewController : BannerViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<CityManagerControllerDelegate> delegate;

@end
