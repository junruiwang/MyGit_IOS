//
//  HotelSearchViewController.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-15.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "HotelSearchViewController.h"
#import "HotelListViewController.h"
#import "NSDateAdditions.h"

@interface HotelSearchViewController ()

@property (nonatomic) BOOL isEctive;

@property (nonatomic, strong) NSMutableArray* faverateCityList;
@property (nonatomic, strong) NSMutableArray* faverateHotelList;
@property (nonatomic, strong) UIView *conditionView;
@property (nonatomic, strong) UIView *citySelectView;

@end

@implementation HotelSearchViewController

- (CityListViewController *)cityListViewController
{
    if (!_cityListViewController)
    {
        _cityListViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                   instantiateViewControllerWithIdentifier:@"CityListViewController"];;
        _cityListViewController.cityListDelegate = self;
    }
    [_cityListViewController downloadData];
    return _cityListViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.mainLabel.text = NSLocalizedStringFromTable(@"hotel search", @"SearchHotel", @"");
    [self.navigationBar addRightBarButton:@"personal_center.png"];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationWhenCityNull)
                                                 name:@"locationCurrentFinished" object:nil];
    
    self.kalManager = [[KalManager alloc] initWithViewController:self];
    self.kalManager.delegate = self;
    
    [self.switchView transformToSearch];
    [self.switchView setNeedsLayout];
    [self.switchView setDelegate:self];
    
    self.remarkView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"remark"]];
    
    [self addPageComponent];
    [self updateLocationWhenCityNull];
    
    [self fillCheckDate];
    
    self.faverateCityList = [NSMutableArray array];
    self.faverateHotelList = [NSMutableArray array];

}

- (void)fillCheckDate
{
    const int checkInDay = [TheAppDelegate.hotelSearchForm.checkinDate day];
    const int checkInMonth = [TheAppDelegate.hotelSearchForm.checkinDate month];
    const int checkOutDay = [TheAppDelegate.hotelSearchForm.checkoutDate day];
    const int checkOutMonth = [TheAppDelegate.hotelSearchForm.checkoutDate month];
    
    self.beginMonthLabel.text = [NSString stringWithFormat:@"%d月", checkInMonth];
    self.checkinDayLabel.text = [NSString stringWithFormat:@"%02u", checkInDay];
    self.endMonthLabel.text = [NSString stringWithFormat:@"%d月", checkOutMonth];
    self.checkoutDayLabel.text = [NSString stringWithFormat:@"%02u", checkOutDay];
    self.beginWeekLabel.text = [self getCNWeek:[TheAppDelegate.hotelSearchForm.checkinDate NSDate]];
    self.endWeekLabel.text = [self getCNWeek:[TheAppDelegate.hotelSearchForm.checkoutDate NSDate]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.citySelectView = self.cityListViewController.view;
    
}

- (void)addPageComponent
{
    UILabel *beginMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 16, 30, 18)];
    beginMonthLabel.text = @"10月";
    beginMonthLabel.font = [UIFont systemFontOfSize:(12)];
    beginMonthLabel.textColor = [UIColor blackColor];
    beginMonthLabel.backgroundColor = [UIColor clearColor];
    self.beginMonthLabel = beginMonthLabel;
    [self.dateBtn addSubview:self.beginMonthLabel];
    
    UILabel *beginWeekLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 30, 28, 18)];
    beginWeekLabel.text = @"周三";
    beginWeekLabel.font = [UIFont systemFontOfSize:(12)];
    beginWeekLabel.textColor = [UIColor blackColor];
    beginWeekLabel.backgroundColor = [UIColor clearColor];
    self.beginWeekLabel = beginWeekLabel;
    [self.dateBtn addSubview:self.beginWeekLabel];
    
    UILabel *checkinDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 12, 38, 41)];
    checkinDayLabel.text = @"08";
    checkinDayLabel.font = [UIFont systemFontOfSize:(33)];
    checkinDayLabel.backgroundColor = [UIColor clearColor];
    self.checkinDayLabel = checkinDayLabel;
    [self.dateBtn addSubview:self.checkinDayLabel];
    
    UILabel *endMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(192, 16, 30, 18)];
    endMonthLabel.text = @"10月";
    endMonthLabel.font = [UIFont systemFontOfSize:(12)];
    endMonthLabel.textColor = [UIColor blackColor];
    endMonthLabel.backgroundColor = [UIColor clearColor];
    self.endMonthLabel = endMonthLabel;
    [self.dateBtn addSubview:self.endMonthLabel];
    
    UILabel *endWeekLabel = [[UILabel alloc] initWithFrame:CGRectMake(195, 30, 30, 18)];
    endWeekLabel.text = @"周四";
    endWeekLabel.font = [UIFont systemFontOfSize:(12)];
    endWeekLabel.textColor = [UIColor blackColor];
    endWeekLabel.backgroundColor = [UIColor clearColor];
    self.endWeekLabel = endWeekLabel;
    [self.dateBtn addSubview:self.endWeekLabel];
    
    UILabel *checkoutDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(226, 12, 38, 41)];
    checkoutDayLabel.text = @"15";
    checkoutDayLabel.font = [UIFont systemFontOfSize:(33)];
    checkoutDayLabel.backgroundColor = [UIColor clearColor];
    self.checkoutDayLabel = checkoutDayLabel;
    [self.dateBtn addSubview:self.checkoutDayLabel];
    
    [self.dateBtn addTarget:self.kalManager action:@selector(pickDate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateLocationWhenCityNull
{
    if (TheAppDelegate.hotelSearchForm.cityName == nil)    {   [self updateCurrentLocation];   return; }
    
    self.cityLabel.text = TheAppDelegate.hotelSearchForm.cityName;
    self.cityLabel.textColor = [UIColor blackColor];
}


- (void)updateCurrentLocation
{
    if (TheAppDelegate.locationInfo.cityName != nil && ![TheAppDelegate.locationInfo.cityName isEqualToString:@""])
    {
        self.cityLabel.text = TheAppDelegate.locationInfo.cityName;
        self.cityLabel.textColor = [UIColor blackColor];
    }
    else
    {
        self.cityLabel.text = @"请选择";
        self.cityLabel.textColor = [UIColor grayColor];
    }
    
    TheAppDelegate.hotelSearchForm.cityName = TheAppDelegate.locationInfo.cityName;
    TheAppDelegate.hotelSearchForm.searchPoint = TheAppDelegate.locationInfo.currentPoint;
    TheAppDelegate.savedLongitude = TheAppDelegate.locationInfo.currentPoint.longitude;
    TheAppDelegate.savedLatitude  = TheAppDelegate.locationInfo.currentPoint.latitude;
}

#pragma mark - CityListDelegate
- (void)selectedCity:(City *)city
{
    if (city == nil) {
        [self handleTap];
        return;
    }
    TheAppDelegate.hotelSearchForm.cityName = city.name;
    BOOL searchSameCity = [TheAppDelegate.locationInfo.cityName isEqualToString:city.name];
    
    if (searchSameCity == YES)
    {
        TheAppDelegate.hotelSearchForm.searchPoint = TheAppDelegate.locationInfo.currentPoint;
        TheAppDelegate.savedLatitude  = TheAppDelegate.locationInfo.currentPoint.latitude;
        TheAppDelegate.savedLongitude = TheAppDelegate.locationInfo.currentPoint.longitude;
    }
    else
    {
        TheAppDelegate.hotelSearchForm.searchPoint = CLLocationCoordinate2DMake(city.latitude, city.longitude);
        TheAppDelegate.savedLatitude  = city.latitude;
        TheAppDelegate.savedLongitude = city.longitude;
    }
    
    if (city.name == nil || [city.name isEqualToString:@""]) {
        self.cityLabel.text = @"请选择";
        self.cityLabel.textColor = [UIColor grayColor];
    } else {
        self.cityLabel.text = city.name;
        self.cityLabel.textColor = [UIColor blackColor];
    }
    TheAppDelegate.hotelSearchForm.area = nil;
    [self handleTap];
}

- (void)handleTap
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.conditionView.frame = CGRectMake(320.0, 0, 320.0, screenRect.size.height);
    }   completion:^(BOOL finished) {
        self.conditionView.hidden = YES;
    }];
}


#pragma mark - KalManagerDelegate
- (void)manager:(KalManager *)manager didSelectMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate
{
    TheAppDelegate.hotelSearchForm.checkinDate = [KalDate dateFromNSDate:minDate];
    TheAppDelegate.hotelSearchForm.checkoutDate = [KalDate dateFromNSDate:maxDate];
    
    [self fillCheckDate];
}

- (IBAction)selectCityPressed:(UIButton *)sender {
    
    [self showViewInSidebar:self.citySelectView title:@"请选择入住城市"];
    
}

- (void)showViewInSidebar:(UIView *)view title:(NSString *)title {
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    
    self.conditionView = view;
    self.conditionView.hidden = NO;
    self.conditionView.frame = CGRectMake(320, 0, 320, screenRect.size.height);
    [self.view addSubview:self.conditionView];
    [self.view bringSubviewToFront:self.conditionView];
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.conditionView.frame = CGRectMake(0, 0, 320, screenRect.size.height);
    } completion:^(BOOL finished) {
        self.conditionView.userInteractionEnabled = YES;
    }];
}

- (NSString *)getCNWeek:(NSDate *)nsDate
{
    const unsigned int weekday = [nsDate cc_weekday];
    NSString *cnWeek = @"";
    switch (weekday)
    {
        case 1:
        {   cnWeek = @"周日"; break;  }
        case 2:
        {   cnWeek = @"周一"; break;  }
        case 3:
        {   cnWeek = @"周二"; break;  }
        case 4:
        {   cnWeek = @"周三"; break;  }
        case 5:
        {   cnWeek = @"周四"; break;  }
        case 6:
        {   cnWeek = @"周五"; break;  }
        case 7:
        {   cnWeek = @"周六"; break;  }
    }
    
    return cnWeek;
}


- (IBAction)searchButtonPressed:(UIButton *)sender {
    
    //GA跟踪搜索按钮
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"酒店搜索页面" withAction:@"酒店搜索" withLabel:@"酒店搜索按钮" withValue:nil];
    [UMAnalyticManager eventCount:@"酒店搜索页面" label:@"酒店搜索页面按钮"];
    
    if (TheAppDelegate.hotelSearchForm.cityName && ![TheAppDelegate.hotelSearchForm.cityName isEqualToString:@""])
    {
//        HotelSearchForm *hsf = TheAppDelegate.hotelSearchForm;
        [self performSegueWithIdentifier:FROM_SEARCH_TO_HOTLE_LIST sender:sender];
    }
    else
    {
        [self showAlertMessage:NSLocalizedStringFromTable(@"please select city", @"SearchHotel", @"")];
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:FROM_SEARCH_TO_HOTLE_LIST])
    {
//        HotelListViewController *hotelListViewController = segue.destinationViewController;
//        [hotelListViewController downloadData];
//        const int yy = hotelListViewController.tableView.frame.origin.y;
//        const unsigned int hh = hotelListViewController.view.frame.size.height - yy;
//        [hotelListViewController.tableView setFrame:CGRectMake(0, yy, 320, hh)];
//        [hotelListViewController.tableView setHidden:NO];
    }
}


#pragma mark - MySwitchViewDelegate

- (void)switchViewDidEndSetting:(MySwitchView*)switchView
{
    if (switchView.on) {
        self.firstSegLabel.textColor = RGBCOLOR(160, 140, 25);
        self.secondSegLabel.textColor = [UIColor blackColor];
    } else {
        self.secondSegLabel.textColor = RGBCOLOR(160, 140, 25);
        self.firstSegLabel.textColor = [UIColor blackColor];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)rightButtonPressed
{
    [self performSegueWithIdentifier:FROM_SEARCH_TO_LOGIN sender:nil];
}

- (void)viewDidUnload {
    [self setSwitchView:nil];
    [self setRemarkView:nil];
    [self setFirstSegLabel:nil];
    [self setSecondSegLabel:nil];
    [self setDateBtn:nil];
    [self setCityBtn:nil];
    [self setCityLabel:nil];
    [super viewDidUnload];
}
@end
