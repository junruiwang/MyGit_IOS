//
//  HotelSearchMapController.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-20.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//
#import <UIKit/UIGestureRecognizer.h>
#import <QuartzCore/QuartzCore.h>
#import "HotelSearchMapController.h"
#import "HotelMapViewController.h"
#import "HotelDetailsViewController.h"
#import "HotelListViewController.h"
#import "HotelTableCell.h"

const unsigned int showNumber = 10;

@interface HotelSearchMapController ()

- (void)showDetail0:(id)sender;
- (void)showDetails:(id)sender;
- (void)locateMyPlace;
- (void)showHotelList;
- (void)setupAnnotions;
- (void)centerMap;
- (void)handleLongPress:(UILongPressGestureRecognizer*)longPressRecognizer;
- (void)addLongPress;
- (void)removeLongPress;

@end

@implementation HotelSearchMapController

@synthesize searchLatitude = _searchLatitude;
@synthesize searchLongitude = _searchLongitude;
@synthesize locationManager = _locationManager;
@synthesize mapView, tableView;
@synthesize parameterManager, hotelListParser;
@synthesize hotelsArray, annotiArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"身边酒店地图页面";
    [super viewWillAppear:animated];
    [self addLongPress];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self removeLongPress];
}

- (void)addLongPress
{
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5;
    [self.navigationController.view addGestureRecognizer:longPress];
    [self.view addGestureRecognizer:longPress];
}

- (void)removeLongPress
{
    [self.view removeGestureRecognizer:longPress];
    [self.navigationController.view removeGestureRecognizer:longPress];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    [self setTitle:@"身边酒店"];
    userLocEnabled = needUpDateData = YES;
    pressPlace = [[HotelAnnotation alloc] init];

    _iOS_version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    self.hotelsArray = [[NSMutableArray alloc] initWithCapacity:20];
    self.annotiArray = [[NSMutableArray alloc] initWithCapacity:20];

    const unsigned int ww = self.view.frame.size.width;
    const unsigned int hh = self.view.frame.size.height;
    self.mapView = [[JJMapView alloc] initWithFrame:CGRectMake(0, 0, ww, hh)];
    [self.mapView setDelegate:self];    isListView = NO;
    [self.view addSubview:self.mapView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setHidden:YES];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];

    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [_locationManager setDistanceFilter:1000.0f];
    //[_locationManager startUpdatingLocation];

    if (!_serialQueue)
    {   _serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL); }   //创建串行队列
    _downloaders = [[NSMutableDictionary alloc] init];
    [self showIndicatorView];[self removeLongPress];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}

- (void)addRightBarButton
{
    list_Btn = [self generateNavButton:@"list.png" action:@selector(showHotelList)];
    list_Btn.frame = CGRectMake(0, 0, 40, 44);
    
    UIBarButtonItem *fullBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:list_Btn];
    self.navigationItem.rightBarButtonItem = fullBarButtonItem;
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)longPressRecognizer
{
    if (longPressRecognizer.state != UIGestureRecognizerStateBegan) // filter the long press end event.
    {   return; }

    [self.mapView removeAnnotations:self.hotelsArray];
    [self.mapView setShowsUserLocation:NO]; needUpDateData = YES;

    CGPoint touchPoint = [longPressRecognizer locationOfTouch:0 inView:self.mapView];
    CLLocationCoordinate2D newCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];

    _currentLatitude    =   newCoordinate.latitude;
    _currentLongitude   =   newCoordinate.longitude;
    _searchLatitude     =   _currentLatitude;
    _searchLongitude    =   _currentLongitude;
    
    [self.mapView removeAnnotation:pressPlace];
    pressPlace = [[HotelAnnotation alloc] initWithName:@"" andSubtitle:@""
                                           andLatitude:_currentLatitude
                                          andLongitude:_currentLongitude];
    [self.mapView addAnnotation:pressPlace];

    [self centerMap];   [self downloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)centerMap
{
	MKCoordinateRegion region;
	region.center.latitude = _searchLatitude;
	region.center.longitude = _searchLongitude;
	region.span.latitudeDelta  = 0.03;
	region.span.longitudeDelta = 0.03;

	[mapView setRegion:region animated:YES];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    _currentLatitude    =   newLocation.coordinate.latitude;
    _currentLongitude   =   newLocation.coordinate.longitude;
    _searchLatitude     =   _currentLatitude;
    _searchLongitude    =   _currentLongitude;

    MKCoordinateRegion region;
    userLocEnabled  =   YES;

	region.center = newLocation.coordinate;
    region.span.latitudeDelta = 0.0138;
    region.span.longitudeDelta = 0.0138;
    BOOL animated = YES;//NO;
    [self.mapView setShowsUserLocation:YES];
	[self.mapView setRegion:region animated:animated];
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (_iOS_version <= 5.8)
    {
        [self hideIndicatorView];   [self addLongPress];
        NSString *errorMessage = (error.code == kCLErrorDenied) ? @"用户拒绝访问，请打开定位服务" : @"无法确定当前位置";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取位置信息出错" message:errorMessage
                                                           delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    BOOL isInRegion = [HotelMapViewController isLatitude:_searchLatitude
                                            andLongitude:_searchLongitude
                                                inRegion:self.mapView.region];
    if (animated == NO && isInRegion == NO)
    {
        [self.mapView setShowsUserLocation:YES];
    }
    else if(animated == NO && isInRegion == YES)
    {
        [self.mapView setShowsUserLocation:YES];
    }
}

- (void)mapView:(MKMapView *)mapView1 didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region;
    userLocEnabled  =   YES;

	region.center = userLocation.coordinate;
    if (self.mapView.region.span.latitudeDelta > 0.085 ||
        self.mapView.region.span.longitudeDelta > 0.085 )
    {
        region.span.latitudeDelta = 0.0138;
        region.span.longitudeDelta = 0.0138;
    }
    else
    {
        region.span.latitudeDelta = self.mapView.region.span.latitudeDelta;
        region.span.longitudeDelta = self.mapView.region.span.longitudeDelta;
    }

    _currentLatitude    =   userLocation.coordinate.latitude;
    _currentLongitude   =   userLocation.coordinate.longitude;
    _searchLatitude     =   _currentLatitude;
    _searchLongitude    =   _currentLongitude;
    [self downloadData];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if (_iOS_version > 5.9)
    {
        [self hideIndicatorView];   [self addLongPress];
        NSString *errorMessage = (error.code == kCLErrorDenied) ? @"用户拒绝访问，请打开定位服务" : @"无法确定当前位置";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取位置信息出错" message:errorMessage
                                                           delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[JJHotel class]])
    {
        // try to dequeue an existing pin view first
        static NSString* labelAnnotationIdentifier = @"LabelAnnotationIdentifier";  //MKAnnotationView

        MKAnnotationView* pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:labelAnnotationIdentifier];

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

        NSString *priceString = (hotelInfo.price) == 0 ? @"已售完" : [[NSString alloc] initWithFormat:NSLocalizedString(@"￥%d", nil), hotelInfo.price];

        tagImage = [tempImage stretchableImageWithLeftCapWidth:40 topCapHeight:0];

        CGRect resizeRect;

        resizeRect.size = CGSizeMake([priceString sizeWithFont:[UIFont systemFontOfSize:18]].width+40, 27);
        resizeRect.origin = (CGPoint){0.0f, 0.0f};
        CGSize newSize = CGSizeMake(resizeRect.size.width, resizeRect.size.height+10);

        if ([UIScreen instancesRespondToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0f)
        {   UIGraphicsBeginImageContextWithOptions(newSize, NO, 2.0f);  }
        else
        {   UIGraphicsBeginImageContext(newSize);   }

        // draw text on image and get the new image as price label
        [tagImage drawInRect:resizeRect];
        [arrowImage drawInRect:CGRectMake((resizeRect.size.width-40)/2, 26, 45, 8)];

        if (hotelInfo.price == 0)
        {   CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor lightTextColor].CGColor);    }
        else
        {   CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor whiteColor].CGColor);        }
        CGContextSetTextDrawingMode(UIGraphicsGetCurrentContext(), kCGTextFill);

        CGRect textRect;
        textRect.size = resizeRect.size;
        textRect.origin = (CGPoint){30.0f, 4.0f};
        [priceString drawInRect:textRect withFont:[UIFont systemFontOfSize:18]];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        pinView.opaque = NO;
        pinView.image = resizedImage;
        if (priceString != nil) {    }

        return pinView;
    }
    else if([annotation isKindOfClass:[HotelAnnotation class]])
    {
        static NSString *defaultPinID = @"LongPress";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (pinView == nil)
        {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
            pinView.pinColor = MKPinAnnotationColorRed;pinView.canShowCallout = YES;
            pinView.animatesDrop = YES;pinView.selected = YES;
        }
        else
        {
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

#pragma mark - 业务逻辑

- (void)downloadDataInGCD
{
    //把block中的任务放入串行队列中执行，这是第一个任务
    dispatch_async(_serialQueue, ^{ [self downloadData];    });
}

- (void)downloadData
{
    if (needUpDateData == NO) { return; }

    [self showIndicatorView];   [self removeLongPress];
    self.navigationController.navigationBar.userInteractionEnabled = YES;

    if (!self.hotelListParser)
    {
        self.hotelListParser = [[HotelListParser alloc] init];
        self.hotelListParser.isHTTPGet = NO;
        self.hotelListParser.serverAddress = kHotelSearchURL;
    }

    self.parameterManager = [[ParameterManager alloc] init];
    [self.parameterManager parserStringWithKey:@"cityName" WithValue:TheAppDelegate.locationInfo.cityName];
    [self.parameterManager parserStringWithKey:@"dateCheckIn" WithValue:[TheAppDelegate.hotelSearchForm.checkinDate chineseDescription]];
    [self.parameterManager parserStringWithKey:@"dateCheckOut" WithValue:[TheAppDelegate.hotelSearchForm.checkoutDate chineseDescription]];
    [self.parameterManager parserStringWithKey:@"brands" WithValue:nil];
    [self.parameterManager parserStringWithKey:@"areaName" WithValue:nil];
    [self.parameterManager parserStringWithKey:@"starRatings" WithValue:TheAppDelegate.hotelSearchForm.starLevel.code];
    [self.parameterManager parserStringWithKey:@"minPrice" WithValue:TheAppDelegate.hotelSearchForm.priceRange.minPrice];
    [self.parameterManager parserStringWithKey:@"maxPrice" WithValue:TheAppDelegate.hotelSearchForm.priceRange.maxPrice];
    [self.parameterManager parserFloatWithKey:@"latitude" WithValue:_searchLatitude];
    [self.parameterManager parserFloatWithKey:@"longitude" WithValue:_searchLongitude];
    [self.parameterManager parserIntegerWithKey:@"pageIndex" WithValue:1];
    [self.parameterManager parserIntegerWithKey:@"length" WithValue:showNumber];
    [self.parameterManager parserStringWithKey:@"orderSequenceForDistance" WithValue:@"asc"];

    self.hotelListParser.requestString = [parameterManager serialization];
    self.hotelListParser.delegate = self;

    CLLocationCoordinate2D searchPoint;
    searchPoint.latitude = _searchLatitude;
    searchPoint.longitude = _searchLongitude;
    TheAppDelegate.hotelSearchForm.searchPoint = searchPoint;
    TheAppDelegate.enterdLBS = YES;

    [self.hotelListParser start];
}

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    [self.hotelsArray removeAllObjects];
    [self.hotelsArray addObjectsFromArray:data[@"hotelList"]];
    [self setupAnnotions];
    [self hideIndicatorView];   needUpDateData = NO;    [self addLongPress];
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    [self hideIndicatorView];   needUpDateData = YES;   [self addLongPress];
    if(code == -1 || code == 10000)
    {   [self showAlertMessageWithOkCancelButton:kNetworkProblemAlertMessage title:nil tag:0 delegate:self];    }
    else
    {   [self showAlertMessageWithOkButton:msg title:nil tag:0 delegate:nil];   }
}

- (void)locateMyPlace
{
    [self.mapView setShowsUserLocation:YES];
}

- (void)showHotelList
{
    if (self.hotelsArray != nil && [self.hotelsArray count] >= 1)
    {
        isListView = !isListView;
        [self.mapView setHidden:isListView];
        const unsigned int hh = self.view.frame.size.height;
        [self.tableView setFrame:CGRectMake(0, 0, 320, hh)];
        [UIView beginAnimations:@"animationID" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationTransition:isListView ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight
                               forView:self.view cache:YES];
        if (isListView)
        {
            [self.tableView setHidden:NO];[self.tableView reloadData];
            [list_Btn setImage:[UIImage imageNamed:@"locate.png"] forState:UIControlStateNormal];
        }
        else
        {
            [self.tableView setHidden:YES];
            [self.mapView setShowsUserLocation:YES];
            [list_Btn setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        }
        [UIView commitAnimations];
    }
}

- (void)setupAnnotions
{
    if (self.hotelsArray == nil || [self.hotelsArray count] <= 0) { return; }

    for (unsigned int i = 0; i < [self.hotelsArray count]; i++)
    {
        JJHotel* hotel = self.hotelsArray[i];
        [hotel setTitle:hotel.name];
        hotel.subtitle = [NSString stringWithFormat:@"距我%0.1f公里", hotel.distance];
        [self.mapView addAnnotation:hotel];
    }

    [self centerMap];
}

- (void)showDetaill:(id)sender
{
    id view = sender; // MKAnnotationView
    if ([view isKindOfClass:[MKAnnotationView class]])
    {
        JJHotel *hotelInfo = (JJHotel *)(((MKAnnotationView *)view).annotation);
        HotelDetailsViewController *detailVC = (HotelDetailsViewController *) [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                                                               instantiateViewControllerWithIdentifier:@"HotelDetailsViewController"];
        [detailVC setHotel:hotelInfo];
        [detailVC setIsFromOrder:NO];[detailVC downloadData];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)showDetail0:(id)sender
{
    id view = [sender superview]; // UICalloutView -> MKAnnotationView
    if ([view isKindOfClass:[MKAnnotationView class]])
    {
        JJHotel *hotelInfo = (JJHotel *)(((MKAnnotationView *)view).annotation);
        HotelDetailsViewController *detailVC = (HotelDetailsViewController *) [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                                                               instantiateViewControllerWithIdentifier:@"HotelDetailsViewController"];
        [detailVC setHotel:hotelInfo];
        [detailVC setIsFromOrder:NO];[detailVC downloadData];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)showDetails:(id)sender
{
    id view = [[sender superview] superview]; // UIButton -> UICalloutView -> MKAnnotationView
    if ([view isKindOfClass:[MKAnnotationView class]])
    {
        JJHotel *hotelInfo = (JJHotel *)(((MKAnnotationView *)view).annotation);
        HotelDetailsViewController *detailVC = (HotelDetailsViewController *) [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                                                               instantiateViewControllerWithIdentifier:@"HotelDetailsViewController"];
        [detailVC setHotel:hotelInfo];
        [detailVC setIsFromOrder:NO];[detailVC downloadData];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotelDetailsViewController *detailVC = (HotelDetailsViewController *) [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]
                                                                           instantiateViewControllerWithIdentifier:@"HotelDetailsViewController"];
    [detailVC setHotel:self.hotelsArray[indexPath.row]];
    [detailVC setIsFromOrder:NO];[detailVC downloadData];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hotelsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

@end
