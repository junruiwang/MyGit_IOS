//
//  CityDetailListViewController.h
//  WeatherReport
//
//  Created by 汪君瑞 on 13-5-18.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "City.h"

@interface CityDetailListViewController : UITableViewController<UISearchDisplayDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDC;
@property (nonatomic, copy) NSString *currentProvince;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableDictionary *fileArray;
@property (nonatomic, strong) NSMutableArray *FilterArray;

@end
