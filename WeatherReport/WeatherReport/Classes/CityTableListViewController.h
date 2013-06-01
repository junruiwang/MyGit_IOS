//
//  CityTableListViewController.h
//  WeatherInfo
//
//  Created by Wu Jing on 11-5-12.
//  Copyright 2011 cfmetinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "City.h"
#import "WeatherDayParser.h"
#import "WeatherAWeekParser.h"

@interface CityTableListViewController : UITableViewController<UISearchDisplayDelegate, BaseParserDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDC;
@property (nonatomic, strong) NSMutableArray *provinceArray;
@property (nonatomic, strong) NSMutableDictionary *fileArray;
@property (nonatomic, strong) NSMutableArray *FilterArray;

@end
