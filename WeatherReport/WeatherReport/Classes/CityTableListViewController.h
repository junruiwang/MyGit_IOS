//
//  CityTableListViewController.h
//  WeatherInfo
//
//  Created by Wu Jing on 11-5-12.
//  Copyright 2011 cfmetinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"


@protocol CityTableListViewDelegate

- (void)citySelected:(NSString *)cityName;

@end

@interface CityTableListViewController : UITableViewController

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDC;
@property (nonatomic, weak) id<CityTableListViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *remainCity;
@property (nonatomic, strong) NSMutableArray *cityNames;
@property (nonatomic, strong) NSMutableArray *allCitys;
@property (nonatomic, strong) NSMutableDictionary *fileArray;
@property (nonatomic, strong) NSArray *FilterArray;

@end
