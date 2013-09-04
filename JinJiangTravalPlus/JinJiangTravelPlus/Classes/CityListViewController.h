//
//  CityListViewController.h
//  JinJiangTravalPlus
//
//  Created by 胡 桂祁 on 11/5/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"
#import "CityListParser.h"

@protocol CityListDelegate <NSObject>

- (void) selectedCity : (City*) city;

@end


@interface CityListViewController : JJViewController <UITableViewDelegate, UITableViewDataSource, GDataXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *cityList;
@property (nonatomic, strong) NSMutableArray *citiesSections;
@property (nonatomic, strong) NSMutableArray *filteredListContent;
@property (nonatomic, strong) City *selectedCity;
@property (nonatomic, strong) UILocalizedIndexedCollation *collation;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) CityListParser *cityListParser;
@property (nonatomic, strong) IBOutlet UITableView *cityListTable;
@property (nonatomic, assign) id<CityListDelegate> cityListDelegate;
@end
