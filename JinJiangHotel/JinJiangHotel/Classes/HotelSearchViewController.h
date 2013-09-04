//
//  HotelSearchViewController.h
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-15.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "JJViewController.h"
#import "MySwitchView.h"
#import "CityListViewController.h"
#import "KalManager.h"

@interface HotelSearchViewController : JJViewController <MySwitchViewDelegate, KalManagerDelegate, CityListDelegate>

@property (weak, nonatomic) IBOutlet UIView *remarkView;
@property (weak, nonatomic) IBOutlet MySwitchView *switchView;
@property (weak, nonatomic) IBOutlet UILabel *firstSegLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondSegLabel;


@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (nonatomic, weak) UILabel *beginMonthLabel;
@property (nonatomic, weak) UILabel *endMonthLabel;
@property (nonatomic, weak) UILabel *beginWeekLabel;
@property (nonatomic, weak) UILabel *endWeekLabel;
@property (nonatomic, weak) UILabel *checkinDayLabel;
@property (nonatomic, weak) UILabel *checkoutDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (nonatomic, strong) CityListViewController *cityListViewController;

@property(nonatomic, strong) KalManager *kalManager;
@end
