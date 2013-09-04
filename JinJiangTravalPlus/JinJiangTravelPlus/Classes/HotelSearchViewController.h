//
//  HotelSearchViewController.h
//  JinJiangTravalPlus
//
//  Created by jerry on 12-11-1.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import "JJViewController.h"
#import "CellButton.h"
#import "BrandListViewController.h"
#import "CityListViewController.h"
#import "ConditionView.h"
#import "KalManager.h"
#import "AreaListViewController.h"
#import "HotelListViewController.h"
#import "MySwitchView.h"

@interface HotelSearchViewController : JJViewController <UITableViewDataSource, UITableViewDelegate, BrandListViewControllerDelegate, CityListDelegate, KalManagerDelegate,AreaListViewDelegate,MySwitchViewDelegate>
{
    CGPoint startLocation;  BOOL locateEnabled;
    
    BOOL isEctive;
}

@property (nonatomic, weak) IBOutlet CellButton *cityBtn;
@property (nonatomic, weak) IBOutlet CellButton *brandBtn;
@property (nonatomic, weak) IBOutlet CellButton *landmarkBtn;
@property (nonatomic, weak) IBOutlet UIButton *dateBtn;

@property (nonatomic, strong) ConditionView *conditionView;
@property (nonatomic, weak) UILabel *beginMonthLabel;
@property (nonatomic, weak) UILabel *endMonthLabel;
@property (nonatomic, weak) UILabel *beginWeekLabel;
@property (nonatomic, weak) UILabel *endWeekLabel;
@property (nonatomic, weak) UILabel *checkinDayLabel;
@property (nonatomic, weak) UILabel *checkoutDayLabel;
@property (nonatomic, strong) CityListViewController *cityListViewController;
@property (nonatomic, strong) BrandListViewController *brandListViewController;
@property (nonatomic, strong) AreaListViewController *areaListViewController;

- (IBAction)showCityListView: (id)sender;
- (IBAction)searchButtonTapped:(id)sender;
- (IBAction)showAreaListView:(id)sender;

@end
