//
//  HotelListViewController.m
//  JinJiangTravalPlus
//
//  Created by Leon on 11/7/12.
//  Copyright (c) 2012 Leon. All rights reserved.
//

#import "HotelListViewController.h"
#import "JJHotel.h"
#import "HotelTableCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "HotelDetailsViewController.h"
#import "ParameterManager.h"
#import "HotelSearchMapController.h"
#import "CloNetworkUtil.h"
#import "Constants.h"

#define kHotelPageSize_20 20
#define kHotelPageSize_10 10
#define kDistanceOrderButtonTag 1001
#define kPriceOrderButtonTag 1002

@interface HotelListViewController ()

@property(nonatomic, strong) UIControl *leftView;

- (void)showHotelList;
- (void)centerMap;
- (void)setupAnnotions;
- (void)showDetails:(id)sender;
- (void)setFilterButtonBackGround;
- (void)handleLongPress:(UILongPressGestureRecognizer*)longPressRecognizer;
- (void)addLongPress;
- (void)removeLongPress;

@end

@implementation HotelListViewController
{
    NSInteger _pageIndex;
    NSInteger _totalHotelCount;
    JJMoreFooter *_moreFooter;
    int _selectSortIndex;
    BOOL _selectSortAcsending;   // YES: ASC, NO: DESC
}

#pragma mark - (id)init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Custom initialization
        _hotelsArray = [[NSMutableArray alloc] init];
        _pageIndex = 1;
        _totalHotelCount = -1;
        _moreFooter = [[JJMoreFooter alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
        _selectSortIndex = kDistanceOrderButtonTag;
        _selectSortAcsending = YES;
        _poi = [[Desitination alloc] initWithCoords:TheAppDelegate.hotelSearchForm.searchPoint];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hotelDateChanged:)
                                                     name:kHotelDateChangedNotification object:nil];
    }
    return self;
}

- (void)addLongPress
{
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5;
    [self.mapView addGestureRecognizer:longPress];
}

- (void)removeLongPress
{
    [self.mapView removeGestureRecognizer:longPress];;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"酒店列表"];
    isListView = YES;
    
    [self setFilterButtonBackGround];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.checkInDateLabel.text = [TheAppDelegate.hotelSearchForm.checkinDate chineseDescription];
    self.checkOutDateLabel.text = [TheAppDelegate.hotelSearchForm.checkoutDate chineseDescription];
    self.distanceOrderButton.tag = kDistanceOrderButtonTag;
    self.priceOrderButton.tag = kPriceOrderButtonTag;
    [self setOrderButtonStyle:self.distanceOrderButton];
    const unsigned int ww = self.view.frame.size.width;
    const unsigned int hh = self.view.frame.size.height;
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, ww, hh)];
    [self.mapView setDelegate:self];
    [self.mapView setHidden:YES];
    [self.mapView setShowsUserLocation:NO];
    [self.view addSubview:self.mapView];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"酒店列表页面";
    [super viewWillAppear:animated];
}

- (void)addRightBarButton
{
    list_Btn = [self generateNavButton:@"locate.png" action:@selector(showHotelList)];
    list_Btn.frame = CGRectMake(0, 0, 40, 44);
    
    UIBarButtonItem *fullBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:list_Btn];
    self.navigationItem.rightBarButtonItem = fullBarButtonItem;
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)longPressRecognizer
{
    if (longPressRecognizer.state != UIGestureRecognizerStateBegan) // filter the long press end event.
    {   return; }
    [self.mapView removeAnnotations:self.hotelsArray];
    CGPoint touchPoint = [longPressRecognizer locationOfTouch:0 inView:self.mapView];
    TheAppDelegate.hotelSearchForm.searchPoint = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    [self moveDestination:TheAppDelegate.hotelSearchForm.searchPoint animated:YES];
    _pageIndex = 1;
    [self downloadData];
}

- (void)moveDestination:(CLLocationCoordinate2D)newCoordinate animated:(BOOL)isAnnimation
{
    [self.mapView deselectAnnotation:self.poi animated:NO];
    MKAnnotationView *annotationView;
    CGRect beginFrame;
    if (isAnnimation)
    {
        annotationView = [self.mapView viewForAnnotation:self.poi];
        beginFrame = annotationView.frame;
    }
    self.poi.subtitle = nil;
    [self.poi setCoordinate:newCoordinate];
    if (isAnnimation)
    {
        CGRect endFrame = annotationView.frame;
        annotationView.frame = beginFrame;
        [UIView beginAnimations:@"moving" context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [annotationView setFrame:endFrame];
        [UIView commitAnimations];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backHome: (id) sender
{
    TheAppDelegate.hotelSearchForm.priceRange = nil;
    TheAppDelegate.hotelSearchForm.starLevel = nil;
    [super backHome:sender];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setCheckInDateLabel:nil];
    [self setCheckOutDateLabel:nil];
    [self setHotelCountLabel:nil];
    [self setPriceOrderButton:nil];
    [self setDistanceOrderButton:nil];
    [self setNoResultLabel:nil];
    [super viewDidUnload];
}


- (ConditionView *)conditionView
{
    if (!_conditionView)
    {
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        _conditionView = [[ConditionView alloc] initWithFrame:CGRectMake(320, 20, 285.0, screenRect.size.height + 20)];
        [self.navigationController.view.window addSubview:_conditionView];
        UISwipeGestureRecognizer *tapGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenConditionView)];
        tapGR.direction = UISwipeGestureRecognizerDirectionRight;
        [_conditionView addGestureRecognizer:tapGR];

        UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(223, 10, 60, 25)];
        [clearBtn setBackgroundImage:[UIImage imageNamed:@"filter_clear.png"] forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clearFilterValue) forControlEvents:UIControlEventTouchUpInside |UIControlEventTouchUpOutside];
        [_conditionView.topView addSubview:clearBtn];
    }

    return _conditionView;
}

- (HotelFilterViewController *)filterViewController
{
    if (!_filterViewController)
    {
        _filterViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                 instantiateViewControllerWithIdentifier:@"HotelFilterViewController"];
        _filterViewController.hotelFilterViewDelegate = self;
    }
    return _filterViewController;
}

- (void)hotelDateChanged:(NSNotification *)notification
{
    self.checkInDateLabel.text = [TheAppDelegate.hotelSearchForm.checkinDate chineseDescription];
    self.checkOutDateLabel.text = [TheAppDelegate.hotelSearchForm.checkoutDate chineseDescription];
    _pageIndex = 1;
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self downloadData];
}

- (void)downloadData
{

    if (!self.hotelListParser)
    {
        self.hotelListParser = [[HotelListParser alloc] init];
        self.hotelListParser.isHTTPGet = NO;
        self.hotelListParser.serverAddress = kHotelSearchURL;
    }

    NSString *orderName = @"";
    switch (_selectSortIndex)
    {
        case kDistanceOrderButtonTag:
        {
            orderName = @"orderSequenceForDistance";
            break;
        }
        case kPriceOrderButtonTag:
        {
            orderName = @"orderSequenceForPrice";
            break;
        }
        default:
        {
            orderName = @"orderSequenceForDistance";
            break;
        }
    }
    NSString *orderVal = @"";
    if (_selectSortAcsending)
    {   orderVal = @"asc";  }
    else
    {   orderVal = @"desc"; }

    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"cityName" WithValue:TheAppDelegate.hotelSearchForm.cityName];
    [parameterManager parserStringWithKey:@"dateCheckIn" WithValue:[TheAppDelegate.hotelSearchForm.checkinDate chineseDescription]];
    [parameterManager parserStringWithKey:@"dateCheckOut" WithValue:[TheAppDelegate.hotelSearchForm.checkoutDate chineseDescription]];
    [parameterManager parserStringWithKey:@"brands" WithValue:TheAppDelegate.hotelSearchForm.hotelBrand.brandCode];
    [parameterManager parserStringWithKey:@"areaName" WithValue:TheAppDelegate.hotelSearchForm.area];
    [parameterManager parserStringWithKey:@"starRatings" WithValue:TheAppDelegate.hotelSearchForm.starLevel.code];
    [parameterManager parserStringWithKey:@"minPrice" WithValue:TheAppDelegate.hotelSearchForm.priceRange.minPrice];
    [parameterManager parserStringWithKey:@"maxPrice" WithValue:TheAppDelegate.hotelSearchForm.priceRange.maxPrice];
    [parameterManager parserFloatWithKey:@"latitude" WithValue:TheAppDelegate.hotelSearchForm.searchPoint.latitude];
    [parameterManager parserFloatWithKey:@"longitude" WithValue:TheAppDelegate.hotelSearchForm.searchPoint.longitude];
    [parameterManager parserIntegerWithKey:@"pageIndex" WithValue:_pageIndex];
    
    CloNetworkUtil *cloNetworkUtil = [[CloNetworkUtil alloc] init];
    NetworkStatus workStatus = [cloNetworkUtil getNetWorkType];
    switch (workStatus) {
        case ReachableViaWiFi:
            [parameterManager parserIntegerWithKey:@"length" WithValue:kHotelPageSize_20];
            break;
        case ReachableViaWWAN:
            [parameterManager parserIntegerWithKey:@"length" WithValue:kHotelPageSize_10];
            break;
        default:
            [parameterManager parserIntegerWithKey:@"length" WithValue:kHotelPageSize_10];
            break;
    }
    
    [parameterManager parserStringWithKey:orderName WithValue:orderVal];
    
    self.hotelListParser.requestString = [parameterManager serialization];
    self.hotelListParser.delegate = self;
    
    [self.hotelListParser start];
    
    self.tableView.tableFooterView = _moreFooter;
    
    if (_pageIndex == 1)
    {
        [self showIndicatorView];
    }
}

- (void)setOrderButtonStyle:(UIButton *)button
{
    [self resetOrderButtonStyle];
    
    
    if (button.tag == kDistanceOrderButtonTag) {
        [button setBackgroundImage:[UIImage imageNamed:@"distince_bg_choose.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"distince_bg_choose.png"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"sort_asc_selected.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"sort_asc_selected.png"] forState:UIControlStateHighlighted];
        [button setTitleColor:RGBCOLOR(255, 146, 45) forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(255, 146, 45) forState:UIControlStateHighlighted];
    } else if (button.tag == kPriceOrderButtonTag) {
        [button setBackgroundImage:[UIImage imageNamed:@"price_bg_choose.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"price_bg_choose.png"] forState:UIControlStateHighlighted];
        
        if (_selectSortAcsending) {
            [button setImage:[UIImage imageNamed:@"sort_asc_selected.png"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"sort_asc_selected.png"] forState:UIControlStateHighlighted];
        } else {
            [button setImage:[UIImage imageNamed:@"sort_desc_selected.png"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"sort_desc_selected.png"] forState:UIControlStateHighlighted];
        }
        
        [button setTitleColor:RGBCOLOR(255, 146, 45) forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(255, 146, 45) forState:UIControlStateHighlighted];
    }
    
//    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
//    button.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 0);
}

- (void)resetOrderButtonStyle
{
    [self.distanceOrderButton setBackgroundImage:[UIImage imageNamed:@"distince_bg.png"] forState:UIControlStateNormal];
    [self.priceOrderButton setBackgroundImage:[UIImage imageNamed:@"price_bg.png"] forState:UIControlStateNormal];
    [self.priceOrderButton setBackgroundImage:[UIImage imageNamed:@"price_bg_choose.png"] forState:UIControlStateHighlighted];
    
    [self.distanceOrderButton setImage:[UIImage imageNamed:@"sort_asc.png"] forState:UIControlStateNormal];
    [self.distanceOrderButton setImage:[UIImage imageNamed:@"sort_asc.png"] forState:UIControlStateHighlighted];
    
    [self.priceOrderButton setImage:[UIImage imageNamed:@"sort_asc.png"] forState:UIControlStateNormal];
    [self.priceOrderButton setImage:[UIImage imageNamed:@"sort_asc.png"] forState:UIControlStateHighlighted];
    
    [self.distanceOrderButton setTitleColor:RGBCOLOR(125, 125, 125) forState:UIControlStateNormal];
    [self.distanceOrderButton setTitleColor:RGBCOLOR(125, 125, 125) forState:UIControlStateHighlighted];
    
    [self.priceOrderButton setTitleColor:RGBCOLOR(125, 125, 125) forState:UIControlStateNormal];
    [self.priceOrderButton setTitleColor:RGBCOLOR(125, 125, 125) forState:UIControlStateHighlighted];
}

- (void)setFilterButtonBackGround
{
    NSString *area = TheAppDelegate.hotelSearchForm.area;
    if ([area isEqualToString:@"全部区域"]) {
        TheAppDelegate.hotelSearchForm.area = nil;
    }
}

- (void)showHotelList
{
    if (self.hotelsArray != nil && [self.hotelsArray count] >= 1)
    {
        isListView = !isListView;
        [UIView beginAnimations:@"animationID" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationTransition:isListView ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight
                               forView:self.view cache:YES];
        if (isListView)
        {
            [self.mapView setHidden:YES];
            [self.tableView setHidden:NO];
            [self removeLongPress];
            [list_Btn setImage:[UIImage imageNamed:@"locate.png"] forState:UIControlStateNormal];
        }
        else
        {
            [self showIndicatorView];
            [self.tableView setHidden:YES];
            [self.mapView setHidden:NO];
            [self addLongPress];
            [self.mapView removeAnnotations:self.hotelsArray];
            [self centerMap];
            [list_Btn setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
            [self performSelector:@selector(setupAnnotions) withObject:nil afterDelay:0.5];
        }
        [UIView commitAnimations];
    }
}

#pragma mark - GDataXMLParserDelegate

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    if (_pageIndex == 1)
    {
        [self.hotelsArray removeAllObjects]; 
    }
    _totalHotelCount = [data[@"total"] intValue];
    
    if (_totalHotelCount == 0)
    {   self.noResultLabel.hidden = NO; }
    else
    {   self.noResultLabel.hidden = YES;    }
    
    [self.hotelsArray addObjectsFromArray:data[@"hotelList"]];
    
    if (self.hotelsArray.count == _totalHotelCount) {
        self.tableView.tableFooterView = nil;
    }

    self.hotelCountLabel.text = [NSString stringWithFormat:@"%d家酒店", _totalHotelCount];
    [self.tableView reloadData];
    //rebuild map view
    if (isListView) {
        [self hideIndicatorView];
    } else {
        [self setupAnnotions];
    }
    
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    [self hideIndicatorView];
    if(code == -1 || code == 10000)
    {   [self showAlertMessageWithOkCancelButton:kNetworkProblemAlertMessage title:nil tag:0 delegate:self];    }
    else
    {
        [self showAlertMessageWithOkButton:msg title:nil tag:0 delegate:nil];
        [self.tableView setTableFooterView:nil];
    }
}

- (UIControl *)leftView
{
    if (!_leftView) {
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        _leftView = [[UIControl alloc] initWithFrame:CGRectMake(0, 20.0, 50.0, screenRect.size.height + 20)];
        [_leftView addTarget:self action:@selector(hiddenConditionView) forControlEvents:UIControlEventTouchUpInside];
        [_leftView setBackgroundColor:[UIColor clearColor]];[_leftView setHidden:YES];
        [self.navigationController.view.window addSubview:_leftView];
    }
    return _leftView;
}

- (IBAction)showFilterView:(id)sender
{
    [self.mapView removeAnnotations:self.hotelsArray];
    [self showFilterConditionView:self.filterViewController.view title:@"筛选"];
}

- (void)showFilterConditionView:(UIView *)view title:(NSString *)title
{
    [self.conditionView addContentView:view];
    self.conditionView.title = title;

    self.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;

    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.conditionView.frame = CGRectMake(35, 20.0, 285.0, screenRect.size.height + 20);
    }                completion:^(BOOL finished) {
        self.conditionView.hidden = NO;
    }];
}

#pragma mark - hiddenCondFitionView window

- (void)hiddenConditionView
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag)
    {
        case 0:
        {
            if (buttonIndex == 1)
            {   [self downloadData];    }
            else if (buttonIndex == 0)
            {
                self.tableView.tableFooterView = nil;
                if (self.hotelsArray.count == 0)
                {   self.noResultLabel.hidden = NO; }
            }
            break;
        }
        default:
        {
            self.tableView.tableFooterView = nil;
            if (self.hotelsArray.count == 0)
            {   self.noResultLabel.hidden = NO; }
            break;
        }
    }
}

- (IBAction)orderButtonTapped:(id)sender
{
    if (sender == self.distanceOrderButton && _selectSortIndex != kDistanceOrderButtonTag)
    {   
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"酒店列表页面"
                                                        withAction:@"酒店列表页面距离排序"
                                                         withLabel:@"酒店列表页面距离排序按钮"
                                                         withValue:nil];
        [UMAnalyticManager eventCount:@"酒店列表页面距离排序" label:@"酒店列表页面距离排序按钮"];
        
        _selectSortAcsending = YES;
        [self reLoadTableViewBySelectTag:sender];
    }
    else if (sender == self.priceOrderButton)
    {
        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"酒店列表页面"
                                                        withAction:@"酒店列表页面价格排序"
                                                         withLabel:@"酒店列表页面价格排序按钮"
                                                         withValue:nil];
        [UMAnalyticManager eventCount:@"酒店列表页面价格排序" label:@"酒店列表页面价格排序按钮"];
        _selectSortAcsending = !_selectSortAcsending;
        [self reLoadTableViewBySelectTag:sender];
    }
}

- (void) reLoadTableViewBySelectTag:(id)sender
{
    _selectSortIndex = [sender tag];
    [self setOrderButtonStyle:sender];
    _pageIndex = 1;
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self downloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender    //  Hotel Detail
{
    if ([segue.identifier isEqualToString:@"showDetail"])
    {
        HotelDetailsViewController *detailVC = (HotelDetailsViewController *)(segue.destinationViewController);
        [detailVC setHotel:self.hotelsArray[[self.tableView indexPathForSelectedRow].row]];
        [detailVC setIsFromOrder:NO];[detailVC downloadData];
    }
}

#pragma mark HotelFilterViewDelegate - closeHotelFilterView

- (void)closeHotelFilterView
{
    [self setFilterButtonBackGround];
    [self hiddenConditionView];
    _pageIndex = 1;
    [self downloadData];
}

#pragma mark HotelFilterViewDelegate - clearFilterValue

-(void)clearFilterValue
{
    TheAppDelegate.hotelSearchForm.priceRange = nil;
    TheAppDelegate.hotelSearchForm.starLevel = nil;
    TheAppDelegate.hotelSearchForm.hotelBrand = nil;
    TheAppDelegate.hotelSearchForm.area = nil;
    [self.filterViewController.navigateTable reloadData];
    [self closeHotelFilterView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hotelsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HotelTableIdentifier = @"HotelTableCell";
    HotelTableCell *cell = [tableView dequeueReusableCellWithIdentifier:HotelTableIdentifier];
    if (cell == nil) {
        cell = [[HotelTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HotelTableIdentifier];
    }
    cell.starView.frame = CGRectMake(249, 60, 66, 9);
    cell.areaLabel.frame = CGRectMake(106, 53, 127, 21);
    
    //cell背景色
    cell.backgroundColor = [UIColor whiteColor];
    //下降阴影
    cell.dropsShadow = NO;
    //圆弧
    cell.cornerRadius = 5;
    //选中行背景色
    cell.selectionGradientStartColor = RGBCOLOR(231, 231, 231);
    cell.selectionGradientEndColor = RGBCOLOR(231, 231, 231);
    //cell之间的分割线
    cell.customSeparatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
    
    cell.iconView.layer.cornerRadius = 3;
    cell.iconView.clipsToBounds = YES;
    [cell prepareForTableView:tableView indexPath:indexPath];
    
    
    JJHotel *hotel = self.hotelsArray[indexPath.row];
    NSString *trimText = [hotel.name  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimText.length >= 9 && hotel.brand == JJHotelBrandJJHOTEL) {
        [cell.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    } else {
        [cell.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    }
    
    cell.nameLabel.text = hotel.name;
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    if (![hotel.hotelRate isEqualToString:@""])
    {
        cell.hotelRateLabel.text = hotel.hotelRate;
        cell.fenLabel.hidden = NO;
    }
    else
    {
        cell.hotelRateLabel.text = nil;
        cell.fenLabel.hidden = YES;
    }
    cell.distanceLabel.text = [NSString stringWithFormat:@"%0.1f公里", hotel.distance];
    if (hotel.price > 0)
    {
        cell.priceLabel.hidden = NO;
        cell.upLabel.hidden = NO;
        cell.dollarLabel.hidden = NO;
        cell.soldoutLabel.hidden = YES;
        cell.priceLabel.text = [NSString stringWithFormat:@"%d", hotel.price];
        [cell.priceLabel sizeToFit];
        CGRect priceFrame = cell.priceLabel.frame;
        const int xx = 277-priceFrame.size.width-3;
        const int yy = priceFrame.origin.y;
        const unsigned int ww = priceFrame.size.width;
        const unsigned int hh = priceFrame.size.height;
        cell.priceLabel.frame = CGRectMake(xx, yy, ww, hh);
        const int xxx = cell.priceLabel.frame.origin.x-12;
        cell.dollarLabel.frame = CGRectMake(xxx, 33, 8, 18);
    }
    else
    {
        cell.priceLabel.hidden = YES;
        cell.upLabel.hidden = YES;
        cell.dollarLabel.hidden = YES;
        cell.soldoutLabel.hidden = NO;
    }
    if (hotel.star > 0) {
        cell.starView.frame = CGRectMake(106, 60, 66, 9);
        cell.areaLabel.frame = CGRectMake(160, 53, 127, 21);
    }
    cell.starView.star = hotel.star;
    cell.areaLabel.text = hotel.zone;
    
    [cell.iconView setImageWithURL:[NSURL URLWithString:hotel.imageUrl] placeholderImage:[UIImage imageNamed:@"defaultHotelIcon.png"]];
    
    //load next page data
    if ((indexPath.row == self.hotelsArray.count-2) && self.hotelsArray.count < _totalHotelCount)
    {
        _pageIndex++;
        [self downloadData];
    }
    
    return cell;
}

//设置group之间的间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showIndicatorView];
    HotelTableCell *cell = (HotelTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    [UMAnalyticManager eventCount:@"酒店列表页面点击进入酒店详情" label:@"酒店列表页面点击进入酒店详情事件"];
    [self performSelector:@selector(pageToDetail:) withObject:cell afterDelay:0.5];
}

- (void)pageToDetail:(HotelTableCell *) cell
{
    [self performSegueWithIdentifier:@"showDetail" sender:nil];
    [self hideIndicatorView];
    [cell setSelected:NO animated:YES];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[JJHotel class]])
    {
        // try to dequeue an existing pin view first
        static NSString *labelAnnotationIdentifier = @"LabelAnnotationIdentifier";

        MKAnnotationView *pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:labelAnnotationIdentifier];

        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:labelAnnotationIdentifier];
            pinView.canShowCallout = YES;

            // add a detail disclosure button to the callout which will open a new view controller page
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [leftButton addTarget:self  action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
            pinView.leftCalloutAccessoryView = leftButton;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self  action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;
        }
        else
        {
            pinView.annotation = annotation;
        }
        
        JJHotel *hotelInfo = (JJHotel *)annotation;

        UIImage *tempImage;
        UIImage *tagImage;
        UIImage *arrowImage;

        // show price label in pin view
        NSString* displayName = @"";
        
        if(hotelInfo.brand == JJHotelBrandJJHOTEL)
        {
            if (hotelInfo.price == 0) {
                tempImage = [UIImage imageNamed:@"售完_锦江.png"];
                arrowImage = [UIImage imageNamed:@"售完_箭头.png"];
            } else {
                tempImage = [UIImage imageNamed:@"锦江酒店边框.png"];
                arrowImage = [UIImage imageNamed:@"金广锦江_箭头.png"];
            }
            displayName = hotelInfo.name;
        }
        else if(hotelInfo.brand == JJHotelBrandSHANGYUE)
        {
            if (hotelInfo.price == 0) {
                tempImage = [UIImage imageNamed:@"售完_商悦.png"];
                arrowImage = [UIImage imageNamed:@"售完_箭头.png"];
            } else {
                tempImage = [UIImage imageNamed:@"商悦边框.png"];
                arrowImage = [UIImage imageNamed:@"商悦箭头.png"];
            }
            displayName = hotelInfo.name;
        }
        else if(hotelInfo.brand == JJHotelBrandJJINN)
        {
            if (hotelInfo.price == 0) {
                tempImage = [UIImage imageNamed:@"售完_锦江之星.png"];
                arrowImage = [UIImage imageNamed:@"售完_箭头.png"];
            } else {
                tempImage = [UIImage imageNamed:@"锦江之星框.png"];
                arrowImage = [UIImage imageNamed:@"锦江之星箭头.png"];
            }
            displayName = @"锦江之星";
        }
        else if(hotelInfo.brand == JJHotelBrandBESTAY)
        {
            if (hotelInfo.price == 0) {
                tempImage = [UIImage imageNamed:@"售完_百时快捷.png"];
                arrowImage = [UIImage imageNamed:@"售完_箭头.png"];
            } else {
                tempImage = [UIImage imageNamed:@"百时边框.png"];
                arrowImage = [UIImage imageNamed:@"百时箭头.png"];
            }
            displayName = @"百时快捷";
        }
        else if(hotelInfo.brand == JJHotelBrandBYL)
        {
            if (hotelInfo.price == 0) {
                tempImage = [UIImage imageNamed:@"售完_白玉兰.png"];
                arrowImage = [UIImage imageNamed:@"售完_箭头.png"];
            } else {
                tempImage = [UIImage imageNamed:@"白玉兰边框.png"];
                arrowImage = [UIImage imageNamed:@"白玉兰箭头.png"];
            }
            displayName = hotelInfo.name;
        }
        else if(hotelInfo.brand == JJHotelBrandJG)
        {
            if (hotelInfo.price == 0) {
                tempImage = [UIImage imageNamed:@"售完_金广.pngg"];
                arrowImage = [UIImage imageNamed:@"售完_箭头.png"];
            } else {
                tempImage = [UIImage imageNamed:@"金广边框.png"];
                arrowImage = [UIImage imageNamed:@"金广锦江_箭头.png"];
            }
            displayName = @"金广快捷";
        }
        else
        {
            if (hotelInfo.price == 0) {
                tempImage = [UIImage imageNamed:@"售完_锦江.png"];
                arrowImage = [UIImage imageNamed:@"售完_箭头.png"];
            } else {
                tempImage = [UIImage imageNamed:@"锦江酒店边框.png"];
                arrowImage = [UIImage imageNamed:@"金广锦江_箭头.png"];
            }
            displayName = hotelInfo.name;
        }

        [displayName trim];

        NSString *priceString = (hotelInfo.price) == 0 ? @"已售完" : [[NSString alloc] initWithFormat:NSLocalizedString(@"￥%d", nil), hotelInfo.price];

        tagImage = [tempImage stretchableImageWithLeftCapWidth:40 topCapHeight:0];

        CGRect resizeRect;

        resizeRect.size = CGSizeMake([priceString sizeWithFont:[UIFont systemFontOfSize:18]].width+40, 27);
        resizeRect.origin = (CGPoint){0.0f, 0.0f};
        CGSize newSize = CGSizeMake(resizeRect.size.width, resizeRect.size.height+10);
        if ([UIScreen instancesRespondToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0f) {
            UIGraphicsBeginImageContextWithOptions(newSize, NO, 2.0f);
        } else {
            UIGraphicsBeginImageContext(newSize);
        }

        // draw text on image and get the new image as price label
        [tagImage drawInRect:resizeRect];
        [arrowImage drawInRect:CGRectMake((resizeRect.size.width-40)/2, 26, 45, 8)];

        if (hotelInfo.price == 0) {
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor lightTextColor].CGColor);
        } else {
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor whiteColor].CGColor);
        }
        CGContextSetTextDrawingMode(UIGraphicsGetCurrentContext(), kCGTextFill);

        CGRect textRect;
        textRect.size = resizeRect.size;
        textRect.origin = (CGPoint){30.0f, 4.0f};
        [priceString drawInRect:textRect withFont:[UIFont systemFontOfSize:18]];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        pinView.opaque = NO;
        pinView.image = resizedImage;
        

        return pinView;
    }
    
    if ([annotation isKindOfClass:[Desitination class]]) {
        static NSString *defaultPinID = @"DestinationPinView";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (pinView == nil)
        {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
            pinView.pinColor = MKPinAnnotationColorRed;
            pinView.canShowCallout = YES;
            pinView.animatesDrop = YES;
            pinView.selected = YES;
        } else {
            pinView.annotation = annotation;
        }
        
        return pinView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if([[view subviews] count] > 0)
    {
        UIView* callOutView = [[view subviews] objectAtIndex:0];
        view.leftCalloutAccessoryView.frame = CGRectMake(0, 0, callOutView.frame.size.width, callOutView.frame.size.height);
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    view.leftCalloutAccessoryView.frame = CGRectMake(0, 0, 0, 0);
}

- (void)centerMap
{
	MKCoordinateRegion region;
    region.center.latitude = self.poi.coordinate.latitude;
	region.center.longitude = self.poi.coordinate.longitude;
    region.span.latitudeDelta  = 0.04;
	region.span.longitudeDelta = 0.04;
	[self.mapView setRegion:region animated:YES];
    
    [self.mapView setCenterCoordinate:self.poi.coordinate animated:YES];
    [self.mapView addAnnotation:self.poi];
}

- (void)setupAnnotions
{
    //clean history data
    [self.mapView removeAnnotations:self.hotelsArray];
    if (self.hotelsArray == nil || [self.hotelsArray count] <= 0) { return; }

    for (unsigned int i = 0; i < [self.hotelsArray count]; i++)
    {
        JJHotel* hotel = self.hotelsArray[i];
        [hotel setTitle:[hotel.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        //判断所选城市是否为用户当前所在城市
        if ([TheAppDelegate.hotelSearchForm.cityName caseInsensitiveCompare:TheAppDelegate.locationInfo.cityName] == NSOrderedSame) {
            hotel.subtitle = [NSString stringWithFormat:@"距我%0.1f公里", hotel.distance];
        }
    }
    [self.mapView addAnnotations:self.hotelsArray];
    [self centerMap];
    [self hideIndicatorView];
}

- (void)showDetails:(id)sender
{
    id view = [[sender superview] superview]; // UIButton -> UICalloutView -> MKAnnotationView
    if ([view isKindOfClass:[MKAnnotationView class]])
    {
        JJHotel *hotelInfo = (JJHotel *)(((MKAnnotationView *)view).annotation);
        HotelDetailsViewController *detailVC = (HotelDetailsViewController *) [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"HotelDetailsViewController"];
        [detailVC setHotel:hotelInfo];
        [detailVC setIsFromOrder:NO];
        [detailVC downloadData];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}





@end
