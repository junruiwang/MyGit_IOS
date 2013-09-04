//
//  HotelSearchViewController.m
//  JinJiangTravalPlus
//
//  Created by jerry on 12-11-1.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HotelSearchViewController.h"
#import "HotelDetailsViewController.h"
#import "NSDateAdditions.h"
#import "CityListViewController.h"
#import "IndexViewController.h"
#import "BrandListViewController.h"
#import "JJAppDelegate.h"
#import "HotelListViewController.h"
#import "AreaListViewController.h"
#import "JJViewController.h"
#import "UIViewController+Categories.h"
#import "UMAnalyticManager.h"
#import "FaverateHotelManager.h"
#import "FaverateCell.h"
#import "JJHotel.h"

const unsigned int cacheMaxCacheAge = 60*60*24;
const int emptyInfoLabelTag = 100;

@interface HotelSearchViewController ()

@property(nonatomic, copy) NSString *conditionTag;
@property(nonatomic, strong) UIControl *leftView;
@property(nonatomic, strong) KalManager *kalManager;
@property(nonatomic, strong) UITableView *faverateTableView;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet MySwitchView *switchView;
@property (nonatomic, strong) FaverateHotelManager *faverateHotelManager;


@property (nonatomic, strong) NSMutableArray* faverateCityList;
@property (nonatomic, strong) NSMutableArray* faverateHotelList;

- (void)addPageComponent;
- (void)fillCheckDate;
- (NSString *)getCNWeek:(NSDate *)nsDate;
- (void)updateLocationWhenCityNull;
- (void)updateBrandWhenExistence;

//select brand
- (void)showBrandView:(id)sender;

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

- (BrandListViewController *)brandListViewController
{
    if (!_brandListViewController)
    {
        _brandListViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                    instantiateViewControllerWithIdentifier:@"BrandListViewController"];
        _brandListViewController.delegate = self;
    }
    return _brandListViewController;
}

- (AreaListViewController *)areaListViewController
{
    _areaListViewController = (AreaListViewController *) [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                                          instantiateViewControllerWithIdentifier:@"AreaListViewController"];
    _areaListViewController.areaListDelegate = self;
    [_areaListViewController downloadData];
    
    return _areaListViewController;
}

- (ConditionView *)conditionView
{
    if (!_conditionView)
    {
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        _conditionView = [[ConditionView alloc] initWithFrame:CGRectMake(320, 20, 285.0, screenRect.size.height + 20)];
        [self.navigationController.view.window addSubview:_conditionView];

        UISwipeGestureRecognizer *tapGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        tapGR.direction = UISwipeGestureRecognizerDirectionRight;
        [_conditionView addGestureRecognizer:tapGR];
    }
    return _conditionView;
}

- (UIControl *)leftView
{
    if (!_leftView)
    {
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        _leftView = [[UIControl alloc] initWithFrame:CGRectMake(0, 20.0, 50.0, screenRect.size.height + 20)];
        [_leftView addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
        [_leftView setBackgroundColor:[UIColor clearColor]];[_leftView setHidden:YES];
        [self.navigationController.view.window addSubview:_leftView];
    }
    return _leftView;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationWhenCityNull)
                                                     name:@"locationCurrentFinished" object:nil];
    }
    return self;
}

- (void)updateLocationWhenCityNull
{
    JJAppDelegate *appDelegate = (JJAppDelegate *) [[UIApplication sharedApplication] delegate];
    if (appDelegate.hotelSearchForm.cityName == nil)    {   [self updateCurrentLocation];   return; }

    [self.cityBtn setTitle:appDelegate.hotelSearchForm.cityName forState:UIControlStateNormal];
    [self.cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
}

- (void)updateBrandWhenExistence
{
    Brand* brand = TheAppDelegate.hotelSearchForm.hotelBrand;

    if (brand != nil && brand.brandCode)
    {
        brand.isSelected = YES;
        [self.brandBtn setTitle:brand.brandName forState:UIControlStateNormal];
        [self blackColorStyleForBtn:self.brandBtn];
    }
    else
    {
        [self.brandBtn setTitle:@"全部品牌" forState:UIControlStateNormal];
        [self grayColorStyleForBtn:self.brandBtn];
    }
}

- (void)updateAreaWhenExistence
{
    NSString *area = TheAppDelegate.hotelSearchForm.area;
    if (area != nil)
    {
        [self.landmarkBtn setTitle:area forState:UIControlStateNormal];
        if([@"全部区域" isEqualToString:area])
        {
            [self grayColorStyleForBtn:self.landmarkBtn];
            return;
        }
        [self blackColorStyleForBtn:self.landmarkBtn];
    }
    else
    {
        [self.landmarkBtn setTitle:@"全部区域" forState:UIControlStateNormal];
        [self grayColorStyleForBtn:self.landmarkBtn];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setTrackedViewName:@"酒店搜索页面"];
    [super viewWillAppear:animated];
    //set default date
    [self fillCheckDate];
    //set brand
    [self updateBrandWhenExistence];
    //set landmark
    [self updateAreaWhenExistence];

    if (TheAppDelegate.enterdLBS == YES)
    {
        CLLocationCoordinate2D position;
        position.latitude  = TheAppDelegate.savedLatitude;
        position.longitude = TheAppDelegate.savedLongitude;
        TheAppDelegate.hotelSearchForm.searchPoint = position;
    }
    self.trackedViewName = @"酒店搜索页面";
    
    self.faverateCityList = [NSMutableArray array];
    self.faverateHotelList = [NSMutableArray array];
    self.faverateHotelManager = [[FaverateHotelManager alloc] init];
    [self.switchView switchOff:nil];
    [self addFaverateView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    self.kalManager = [[KalManager alloc] initWithViewController:self];
    self.kalManager.delegate = self;
    
    [self.switchView transformToSearch];
    self.switchView.delegate = self;

    //add page component
    [self addPageComponent];
    //set default date
    [self fillCheckDate];
    //set location
    [self updateLocationWhenCityNull];
    //set brand
    [self updateBrandWhenExistence];
    //set landmark
    [self updateAreaWhenExistence];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.conditionView removeFromSuperview];
    [self.leftView removeFromSuperview];
}

- (void)manager:(KalManager *)manager didSelectMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate
{
    TheAppDelegate.hotelSearchForm.checkinDate = [KalDate dateFromNSDate:minDate];
    TheAppDelegate.hotelSearchForm.checkoutDate = [KalDate dateFromNSDate:maxDate];

    [self fillCheckDate];
}

- (IBAction)searchButtonTapped:(id)sender
{
    //GA跟踪搜索按钮
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"酒店搜索页面" withAction:@"酒店搜索" withLabel:@"酒店搜索按钮" withValue:nil];
    [UMAnalyticManager eventCount:@"酒店搜索页面" label:@"酒店搜索页面按钮"];
    
    if (TheAppDelegate.hotelSearchForm.cityName && ![TheAppDelegate.hotelSearchForm.cityName isEqualToString:@""])
    {
        [self performSegueWithIdentifier:@"SearchHotel" sender:sender];
    }
    else
    {
        [self showAlertMessage:@"请选择城市！"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchHotel"])
    {
        HotelListViewController *hotelListViewController = segue.destinationViewController;
        [hotelListViewController downloadData];
        const int yy = hotelListViewController.tableView.frame.origin.y;
        const unsigned int hh = hotelListViewController.view.frame.size.height - yy;
        [hotelListViewController.tableView setFrame:CGRectMake(0, yy, 320, hh)];
        [hotelListViewController.tableView setHidden:NO];
    }
}

- (void)addPageComponent
{
    [self.searchButton.titleLabel.layer setShadowOffset: CGSizeMake(0, -5)];
    [self.searchButton.titleLabel.layer setShadowColor: [UIColor whiteColor].CGColor];
    self.filterView.layer.borderWidth = 0.5;
    self.filterView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.filterView.layer.shadowOffset = CGSizeMake(5, 5);
    self.filterView.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.filterView.layer setMasksToBounds:YES];
    
    self.cityBtn.leftLabel.text = @"请选择";
    self.cityBtn.leftImage = [UIImage imageNamed:@"search_icon_region"];
    
    self.brandBtn.leftImage = [UIImage imageNamed:@"search_icon_brand"];
    
    self.landmarkBtn.leftLabel.text = @"全部区域";
    self.landmarkBtn.leftImage = [UIImage imageNamed:@"search_icon_district"];

    [self.dateBtn setBackgroundImage:[[UIImage imageNamed:@"common_btn_press.png"]
                                      stretchableImageWithLeftCapWidth:5 topCapHeight:0]
                            forState:(UIControlStateHighlighted)];
    [self.dateBtn addTarget:self.kalManager action:@selector(pickDate) forControlEvents:UIControlEventTouchUpInside];
    [self.brandBtn addTarget:self action:@selector(showBrandView:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *checkinDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 8, 56, 18)];
    checkinDateLabel.text = @"入住";
    checkinDateLabel.font = [UIFont systemFontOfSize:(12)];
    checkinDateLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:140.0/255.0 blue:202.0/255.0 alpha:1.0];
    checkinDateLabel.backgroundColor = [UIColor clearColor];
    [self.dateBtn addSubview:checkinDateLabel];

    UILabel *checkoutDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(206, 8, 56, 18)];
    checkoutDateLabel.text = @"离店";
    checkoutDateLabel.font = [UIFont systemFontOfSize:(12)];
    checkoutDateLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:202.0/255.0 alpha:1.0];
    checkoutDateLabel.backgroundColor = [UIColor clearColor];
    [self.dateBtn addSubview:checkoutDateLabel];

    UILabel *daoLabel = [[UILabel alloc] initWithFrame:CGRectMake(133, 34, 14, 18)];
    daoLabel.text = @"/";
    daoLabel.font = [UIFont systemFontOfSize:(33)];
    daoLabel.textColor = [UIColor lightGrayColor];
    daoLabel.backgroundColor = [UIColor clearColor];
    [self.dateBtn addSubview:daoLabel];

    UIImage *leftImage = [UIImage imageNamed:@"search_icon_date.png"];
    const unsigned int w0 = leftImage.size.width;
    const unsigned int h0 = leftImage.size.height;
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 22, w0, h0)];
    leftImageView.image = leftImage;
    [self.dateBtn addSubview:leftImageView];

    UIImage *rightImage = [UIImage imageNamed:@"hotel-next.png"];
    const int x1 = (self.dateBtn.frame.size.width - rightImage.size.width - 16);
    const int y1 = (self.dateBtn.frame.size.height - 30);
    const unsigned int w1 = rightImage.size.width;
    const unsigned int h1 = rightImage.size.height;
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x1, y1, w1, h1)];
    rightImageView.image = rightImage;
    [self.dateBtn addSubview:rightImageView];

    UILabel *beginMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 24, 30, 18)];
    beginMonthLabel.text = @"10月";
    beginMonthLabel.font = [UIFont systemFontOfSize:(12)];
    beginMonthLabel.textColor = [UIColor blackColor];
    beginMonthLabel.backgroundColor = [UIColor clearColor];
    self.beginMonthLabel = beginMonthLabel;
    [self.dateBtn addSubview:self.beginMonthLabel];

    UILabel *endMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 24, 30, 18)];
    endMonthLabel.text = @"10月";
    endMonthLabel.font = [UIFont systemFontOfSize:(12)];
    endMonthLabel.textColor = [UIColor blackColor];
    endMonthLabel.backgroundColor = [UIColor clearColor];
    self.endMonthLabel = endMonthLabel;
    [self.dateBtn addSubview:self.endMonthLabel];

    UILabel *beginWeekLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 38, 28, 18)];
    beginWeekLabel.text = @"周三";
    beginWeekLabel.font = [UIFont systemFontOfSize:(12)];
    beginWeekLabel.textColor = [UIColor blackColor];
    beginWeekLabel.backgroundColor = [UIColor clearColor];
    self.beginWeekLabel = beginWeekLabel;
    [self.dateBtn addSubview:self.beginWeekLabel];

    UILabel *endWeekLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 38, 30, 18)];
    endWeekLabel.text = @"周四";
    endWeekLabel.font = [UIFont systemFontOfSize:(12)];
    endWeekLabel.textColor = [UIColor blackColor];
    endWeekLabel.backgroundColor = [UIColor clearColor];
    self.endWeekLabel = endWeekLabel;
    [self.dateBtn addSubview:self.endWeekLabel];

    UILabel *checkinDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 20, 38, 41)];
    checkinDayLabel.text = @"08";
    checkinDayLabel.font = [UIFont systemFontOfSize:(33)];
    checkinDayLabel.backgroundColor = [UIColor clearColor];
    self.checkinDayLabel = checkinDayLabel;
    [self.dateBtn addSubview:self.checkinDayLabel];

    UILabel *checkoutDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(196, 20, 38, 41)];
    checkoutDayLabel.text = @"15";
    checkoutDayLabel.font = [UIFont systemFontOfSize:(33)];
    checkoutDayLabel.backgroundColor = [UIColor clearColor];
    self.checkoutDayLabel = checkoutDayLabel;
    [self.dateBtn addSubview:self.checkoutDayLabel];
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


- (void)blackColorStyleForBtn:(CellButton *)cellBtn
{
    [cellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
}

- (void)grayColorStyleForBtn:(CellButton *)cellBtn
{
    [cellBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cellBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
}

- (void)updateCurrentLocation
{
    JJAppDelegate *appDelegate = (JJAppDelegate *) [[UIApplication sharedApplication] delegate];
    if (appDelegate.locationInfo.cityName != nil && ![appDelegate.locationInfo.cityName isEqualToString:@""])
    {
        [self.cityBtn setTitle:appDelegate.locationInfo.cityName forState:UIControlStateNormal];
        [self blackColorStyleForBtn:self.cityBtn];
        [self.cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.cityBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [self grayColorStyleForBtn:self.cityBtn];
        [self.cityBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    }
    appDelegate.hotelSearchForm.cityName = appDelegate.locationInfo.cityName;
    appDelegate.hotelSearchForm.searchPoint = appDelegate.locationInfo.currentPoint;
    TheAppDelegate.savedLongitude = appDelegate.locationInfo.currentPoint.longitude;
    TheAppDelegate.savedLatitude  = appDelegate.locationInfo.currentPoint.latitude;
}


#pragma mark - BrandListViewControllerDelegate

- (void)pickBrandDone:(Brand*)brand
{
    [self.brandBtn setTitle:brand.brandName forState:UIControlStateNormal];

    if (brand.brandCode == nil)
    {
        [self.brandBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.brandBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        TheAppDelegate.hotelSearchForm.hotelBrand = nil;
    }
    else
    {
        [self.brandBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.brandBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        TheAppDelegate.hotelSearchForm.hotelBrand = brand;
        if (![TheAppDelegate.hotelSearchForm.hotelBrand isDefault])
        {
            TheAppDelegate.hotelSearchForm.hotelBrand.isSelected = YES;
        }
        
    }

    [self handleTap];
}

#pragma mark - CityListDelegate

- (void)selectedCity:(City *)city
{
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
        [self.cityBtn setTitle:@"请选择"];
        [self grayColorStyleForBtn:self.cityBtn];
    } else {
        [self.cityBtn setTitle:city.name];
        [self blackColorStyleForBtn:self.cityBtn];
    }
    [self.landmarkBtn setTitle:@"全部区域"];
    TheAppDelegate.hotelSearchForm.area = nil;
    [self grayColorStyleForBtn:self.landmarkBtn];
    [self handleTap];
}

- (void)showViewInSidebar:(UIView *)view title:(NSString *)title {
    [self.conditionView addContentView:view];
    self.conditionView.title = title;
    
    self.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.conditionView.frame = CGRectMake(35, 20.0, 285.0, screenRect.size.height + 20);
    }                completion:^(BOOL finished) {
        self.leftView.hidden = NO;
    }];
}

- (IBAction)showCityListView:(id)sender
{
    [self showViewInSidebar:self.cityListViewController.view title:@"请选择入住城市"];
}

- (void)showBrandView:(id)sender
{
    [self showViewInSidebar:self.brandListViewController.view title:@"请选择酒店品牌"];
}

- (IBAction)showAreaListView:(id)sender
{
    [self showViewInSidebar:self.areaListViewController.view title:@"请选择行政区域"];
}

- (void)handleTap
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.conditionView.frame = CGRectMake(320.0, 20.0, 285.0, screenRect.size.height + 20);
    }   completion:^(BOOL finished) {
        self.leftView.hidden = YES;
        self.view.userInteractionEnabled = YES;
        self.navigationController.navigationBar.userInteractionEnabled = YES;
    }];
}


- (void)addFaverateView
{
    if (self.faverateTableView == nil) {
        self.faverateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, 320, 360)
                                                              style:UITableViewStylePlain];
        
        [self.faverateTableView setDataSource:self];
        [self.faverateTableView setDelegate:self];
        self.faverateTableView.backgroundColor = [UIColor whiteColor];
        self.faverateTableView.separatorColor = [UIColor clearColor];
        [self.view addSubview:self.faverateTableView];
    }
    
    UILabel *emptyFaverateLabel = (UILabel *)[self.view viewWithTag:emptyInfoLabelTag];
    if (emptyFaverateLabel != nil) {
        [emptyFaverateLabel removeFromSuperview];
        emptyFaverateLabel = nil;
    }
    [self.faverateHotelManager selectDistinctCityIntoArray:self.faverateCityList];
    if (self.faverateCityList.count < 1) {
        emptyFaverateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 320, 30)];
        emptyFaverateLabel.tag = emptyInfoLabelTag;
        emptyFaverateLabel.text = @"未收藏任何酒店";
        emptyFaverateLabel.textAlignment = NSTextAlignmentCenter;
        [self.faverateTableView addSubview:emptyFaverateLabel];
    }
    
    
    
    for (unsigned int i = 0; i < self.faverateCityList.count; i++)
    {
        NSString* city = [self.faverateCityList objectAtIndex:i];
        NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:10];
        NSMutableArray* list0 = [[NSMutableArray alloc] initWithCapacity:10];
        [self.faverateHotelManager selectHotelsInFaverateByCity:city intoArray:array];
        for (NSDictionary *faverateHotel in array)
        {
            NSString* hotelName = [faverateHotel valueForKey:@"hotelName"];
            NSString* hotelIDst = [faverateHotel valueForKey:@"hotelId"];
            NSString* hotelCity = [faverateHotel valueForKey:@"cityName"];
            NSString* hotelBrad = [faverateHotel valueForKey:@"brand"];
            
            JJHotel* hotel = [[JJHotel alloc] init];
            [hotel setBrand:[hotelBrad integerValue]];
            [hotel setCityName:hotelCity];
            [hotel setHotelId:[hotelIDst integerValue]];
            [hotel setName:hotelName];
            
            [list0 addObject:hotel];
        }
        
        [self.faverateHotelList addObject:list0];
    }
    self.faverateTableView.hidden = YES;
    [self.faverateTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.faverateCityList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSMutableArray*)[self.faverateHotelList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FaverateCell *cell = [tableView dequeueReusableCellWithIdentifier:FaverateCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[FaverateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FaverateCellIdentifier];
    }
    
    const unsigned int section = indexPath.section;
    const unsigned int row = indexPath.row;
    
    JJHotel* hotel = (JJHotel*)[[self.faverateHotelList objectAtIndex:section] objectAtIndex:row];
    
    NSString *hotelName = [hotel.name length] > 11 ? [NSString stringWithFormat:@"%@...", [hotel.name substringToIndex:11]] : hotel.name;
    
    [cell.textLabel setText:hotelName];
    [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    [cell setHotelID:hotel.hotelId];
    [cell setIndentationLevel:6];
    
    switch (hotel.brand)
    {
        case JJHotelBrandJJHOTEL:
        {   [cell.brandImg setImage:[UIImage imageNamed:@"jinjianghotel.png"]]; break;  }
        case JJHotelBrandSHANGYUE:
        {   [cell.brandImg setImage:[UIImage imageNamed:@"shangyue.png"]]; break;       }
        case JJHotelBrandJJINN:
        {   [cell.brandImg setImage:[UIImage imageNamed:@"jinjiangstart.png"]]; break;  }
        case JJHotelBrandBESTAY:
        {   [cell.brandImg setImage:[UIImage imageNamed:@"baishikuaijie.png"]]; break;  }
        case JJHotelBrandBYL:
        {   [cell.brandImg setImage:[UIImage imageNamed:@"baiyulan.png"]]; break;       }
        default:    {   break;  }
    }
//    
//    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, 320, 1)];
//    line.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"dashed.png"]
//                                                           stretchableImageWithLeftCapWidth:20 topCapHeight:0]];
//    [cell addSubview:line];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    const float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (version >= 5.8)
    {
        UIView* view1 = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FaverateSectionreuseIdentifier];
        UITableViewHeaderFooterView* header = (UITableViewHeaderFooterView*)view1;
        if (header == nil)
        {
            header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:FaverateSectionreuseIdentifier];
        }
        [header setTintColor:[UIColor whiteColor]];
        [header.textLabel setText:[self.faverateCityList objectAtIndex:section]];
        [header.textLabel setFont:[UIFont systemFontOfSize:16]];
        
        return header;
    }
    else
    {
        NSString *sectionTitle = [self.faverateCityList objectAtIndex:section];
        if (sectionTitle == nil) {  return nil; }
        
        // Create label with section title
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(11, 0, 300, 24);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.0 green:0.67 blue:0.62 alpha:1.0];
        label.shadowOffset = CGSizeMake(0.0, 1.0);
        label.font = [UIFont boldSystemFontOfSize:16];
        label.text = sectionTitle; const unsigned int ww = tableView.bounds.size.width;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ww, 20)];
        view.backgroundColor = [UIColor colorWithRed:0.96 green:0.93 blue:0.93 alpha:1.0];
        
        [view addSubview:label];
        
        return view;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    
    const unsigned int section = indexPath.section;
    const unsigned int row = indexPath.row;
    JJHotel* hotel = (JJHotel*)[[self.faverateHotelList objectAtIndex:section] objectAtIndex:row];
    
    HotelDetailsViewController* detailVC = (HotelDetailsViewController *) [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                                                           instantiateViewControllerWithIdentifier:@"HotelDetailsViewController"];
    [detailVC setHotel:hotel];[detailVC setIsFromOrder:YES];[detailVC downloadData];
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - MySwitchViewDelegate

- (void)switchViewDidEndSetting:(MySwitchView*)switchView
{
    isEctive = !switchView.on;
    if (isEctive) {
        self.faverateTableView.hidden = YES;
    } else {
        
        self.faverateTableView.hidden = NO;
    }
}


#pragma mark - AreaListDelegate -callback
- (void)selectArea:(NSString *)areaName
{
    [self.landmarkBtn setTitle:areaName];
    if ([areaName isEqualToString:@"全部区域"])
    {
        [self grayColorStyleForBtn:self.landmarkBtn];
        TheAppDelegate.hotelSearchForm.area = nil;
    }
    else
    {
        [self.landmarkBtn setTitle:areaName forState:UIControlStateNormal];
        [self blackColorStyleForBtn:self.landmarkBtn];
        TheAppDelegate.hotelSearchForm.area = areaName;
    }
    [self handleTap];
}


- (void)viewDidUnload {
    [self setFilterView:nil];
    [self setSearchButton:nil];
    [self setSwitchView:nil];
    [super viewDidUnload];
}
@end
