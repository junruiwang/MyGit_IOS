//
//  HotelMapViewController.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-18.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "HotelMapViewController.h"
#import "HotelAnnotation.h"
#import "JSONKit.h"
#import "Constants.h"

#define EARTH_RADIUS 6378.137
#define kGoogleSearchAddressURL @"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false"

@interface HotelMapViewController ()

@property(nonatomic, strong) UIView *addressView;

- (void)centerMap:(id<MKAnnotation>)palce;
- (void)searchLocation;
- (void)setDestenation:(NSString*)str;
- (void)centerMap;
- (void)locateMyPlace;
- (void)addHotelAnnotation;
- (double)getDistanceWithLat1:(double)lat1 andLng1:(double)lng1
                      andLat2:(double)lat2 andLng2:(double)lng2;
- (void)addHotelAddressView;

@end

@implementation HotelMapViewController

@synthesize routes = _routes;
@synthesize hotelName;
@synthesize hotelAddress;
@synthesize mapView;
@synthesize hotelLatitude;
@synthesize hotelLongitude;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:self.hotelName];

    const unsigned int ww = self.view.frame.size.width;
    const unsigned int hh = self.view.frame.size.height;
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, ww, hh)];
    [self.mapView setDelegate:self];
    [self.view addSubview:self.mapView];
    [self addHotelAddressView];
    _routes = [[NSMutableArray alloc] initWithCapacity:2];
    HotelAnnotation* hotel = [[HotelAnnotation alloc] initWithName:self.hotelName andSubtitle:self.hotelAddress
                                                       andLatitude:self.hotelLatitude andLongitude:self.hotelLongitude];
    HotelAnnotation* myLoc = [[HotelAnnotation alloc] init];
    [_routes addObject:hotel]; [_routes addObject:myLoc];
    [self addHotelAnnotation];
    //[self searchLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"酒店概览页面酒店周边";
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.addressView.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locateMyPlace
{
    [self.mapView setShowsUserLocation:YES];
}

- (void)addHotelAddressView
{
    self.addressView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40-45, 320, 45)];
    self.addressView.backgroundColor = [UIColor darkGrayColor];
    self.addressView.hidden = YES;
    
    UILabel *hotelNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 240, 15)];
    hotelNameLabel.backgroundColor = [UIColor clearColor];
    hotelNameLabel.text = self.hotelName;
    hotelNameLabel.textColor = [UIColor whiteColor];
    hotelNameLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.addressView addSubview:hotelNameLabel];
    
    UILabel *hotelAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 240, 20)];
    hotelAddressLabel.backgroundColor = [UIColor clearColor];
    hotelAddressLabel.text = self.hotelAddress;
    hotelAddressLabel.textColor = [UIColor whiteColor];
    hotelAddressLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.addressView addSubview:hotelAddressLabel];
    
    UIButton *copyButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 5, 60, 30)];
    [copyButton addTarget:self action:@selector(copyAddressToPanel) forControlEvents:UIControlEventTouchUpInside];
    [copyButton setImage:[UIImage imageNamed:@"copy_address.png"] forState:UIControlStateNormal];
    [copyButton setImage:[UIImage imageNamed:@"copy_address_press.png"] forState:UIControlStateHighlighted];
    [self.addressView addSubview:copyButton];
    
    [self.view addSubview:self.addressView];
}

- (void)copyAddressToPanel
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *pasteContext = [NSString stringWithFormat:@"%@ %@", self.hotelName, self.hotelAddress];
    [pasteboard setString:pasteContext];
}

- (void)searchLocation
{
    NSString* urlStr = [NSString stringWithFormat:kGoogleSearchAddressURL, self.hotelAddress];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    @try
    {
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    @catch (NSException *exception)
    {

    }
    @finally
    {

    }
}

- (void)centerMap:(id<MKAnnotation>)palce
{
	MKCoordinateRegion region;

	region.center = palce.coordinate;
    region.span.latitudeDelta = 0.0085;
    region.span.longitudeDelta = 0.0085;
    BOOL animated = YES;
	[self.mapView setRegion:region animated:animated];
}

- (void)centerMap
{
	MKCoordinateRegion region;

	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
	for(unsigned int idx = 0; idx < self.routes.count; idx++)
	{
		HotelAnnotation* currentLocation = (HotelAnnotation*)[self.routes objectAtIndex:idx];
		if(currentLocation.latitude > maxLat)
        {   maxLat = currentLocation.latitude;  }
		if(currentLocation.latitude < minLat)
        {   minLat = currentLocation.latitude;  }
		if(currentLocation.longitude > maxLon)
        {   maxLon = currentLocation.longitude; }
		if(currentLocation.longitude < minLon)
        {   minLon = currentLocation.longitude; }
	}
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = (maxLat - minLat) + 0.0108;
	region.span.longitudeDelta = (maxLon - minLon) + 0.0108;
	
	[mapView setRegion:region animated:YES];
}

- (void)setDestenation:(NSString*)str
{
    NSMutableDictionary* dict0 = (NSMutableDictionary*)[str objectFromJSONString];
    NSArray* results = [dict0 objectForKey:@"results"];
    if ([results count] <= 0) {     return;    }

    NSMutableDictionary* results0 = [results objectAtIndex:0];
    NSMutableDictionary* geometry = [results0 objectForKey:@"geometry"];
    NSMutableDictionary* location = [geometry objectForKey:@"location"];
    const float lat = [[location objectForKey:@"lat"] floatValue];
    const float lng = [[location objectForKey:@"lng"] floatValue];

    HotelAnnotation* hotel = (HotelAnnotation*)[self.routes objectAtIndex:0];
    [hotel setDescription:self.hotelAddress];
    [hotel setName:self.hotelName];
    [hotel setLatitude:lat]; [hotel setLongitude:lng];

    [self addHotelAnnotation];
}

- (void)addHotelAnnotation
{
    HotelAnnotation* newAnnotation = [[HotelAnnotation alloc] initWithName:self.hotelName
                                                               andSubtitle:self.hotelAddress
                                                               andLatitude:hotelLatitude
                                                              andLongitude:hotelLongitude];
    [self.mapView addAnnotation:newAnnotation];
    [self centerMap:newAnnotation];
    //[self.mapView setShowsUserLocation:[[NSUserDefaults standardUserDefaults] boolForKey:USER_CITY_SAME_LOC]];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self setDestenation:str];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    BOOL isInRegion = [HotelMapViewController isLatitude:_currentLatitude
                                            andLongitude:_currentLongitude
                                                inRegion:self.mapView.region];
    if (animated == NO && isInRegion == NO)
    {   [self.mapView setShowsUserLocation:NO];     }
    else if(animated == NO && isInRegion == YES)
    {   [self.mapView setShowsUserLocation:YES];    }
}

- (void)mapView:(MKMapView *)mapView1 didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _currentLatitude = userLocation.coordinate.latitude;
    _currentLongitude = userLocation.coordinate.longitude;

    CLLocationCoordinate2D searchPoint;
    searchPoint.latitude = _currentLatitude;
    searchPoint.longitude = _currentLongitude;
    TheAppDelegate.hotelSearchForm.searchPoint = searchPoint;

//    const float s = [self getDistanceWithLat1:hotelLatitude andLng1:hotelLongitude
//                                      andLat2:_currentLatitude andLng2:_currentLongitude];

    HotelAnnotation* myLoc = (HotelAnnotation*)[self.routes objectAtIndex:1];
    [myLoc setDescription:@""]; [myLoc setName:@"我的位置"];
    [myLoc setLatitude:_currentLatitude]; [myLoc setLongitude:_currentLongitude];

    //if (s <= 15) {  [self centerMap]; }
}

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    
//}

+ (BOOL)isLatitude:(double)latitude andLongitude:(double)longitude inRegion:(MKCoordinateRegion)region
{
    CLLocationCoordinate2D center   = region.center;
    CLLocationCoordinate2D northWestCorner, southEastCorner;

    northWestCorner.latitude  = center.latitude  - (region.span.latitudeDelta  / 2.0);
    northWestCorner.longitude = center.longitude - (region.span.longitudeDelta / 2.0);
    southEastCorner.latitude  = center.latitude  + (region.span.latitudeDelta  / 2.0);
    southEastCorner.longitude = center.longitude + (region.span.longitudeDelta / 2.0);

    if (latitude  >= northWestCorner.latitude &&
        latitude  <= southEastCorner.latitude &&
        longitude >= northWestCorner.longitude &&
        longitude <= southEastCorner.longitude  )
    {   return YES; }
    else { return NO;  }
}

- (double)rad:(double)d
{
    return d * M_PI / 180.0;
}

- (double)getDistanceWithLat1:(double)lat1 andLng1:(double)lng1
                      andLat2:(double)lat2 andLng2:(double)lng2
{
    double radLat1 = [self rad:lat1];
    double radLat2 = [self rad:lat2];
    double a = radLat1 - radLat2;
    double b = [self rad:lng1] - [self rad:lng2];
    
    double s = 2 * asin(sqrt(pow(sin(a/2),2) + cos(radLat1)*cos(radLat2)*pow(sin(b/2),2)));
    s = s * EARTH_RADIUS;   return s;
}

@end
