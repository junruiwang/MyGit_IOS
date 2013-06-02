//
//  BannerViewController.h
//  WeatherReport
//
//  Created by jerry on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "WeatherIndexViewController.h"
#import "ModelWeather.h"
#import "AppDelegate.h"

@interface WeatherIndexViewController ()

@property(nonatomic, strong) ModelWeather *weather;

@end

@implementation WeatherIndexViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"four";
    float imageHeight = 367;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        imageHeight += 88;
    }
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imageHeight)];
    bgImageView.backgroundColor = [UIColor clearColor];
    bgImageView.image = [UIImage imageNamed:@"1-cloudy-night-bg.jpg"];
    [self.view addSubview:bgImageView];
    
    UIView *alpiaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imageHeight)];
    alpiaView.backgroundColor = [UIColor blackColor];
    alpiaView.alpha = 0.5;
    [self.view addSubview:alpiaView];
    
    [self loadScrollView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.weather = TheAppDelegate.modelWeather;
    [self loadWeatherIndexPage];
}

- (void)loadScrollView
{
    float scrollHeight = 412;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        scrollHeight += 88;
    }
    
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,scrollHeight)];
	self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor=[UIColor clearColor];
    self.scrollView.contentSize=CGSizeMake(self.view.frame.size.width,800);
    [self.view addSubview:self.scrollView];
}

- (void)loadWeatherIndexPage
{
    NSArray *scrollSubViews = [self.scrollView subviews];
    for (UIView *view in scrollSubViews) {
        [view removeFromSuperview];
    }
    //穿衣指数
    UIImageView *dressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,46)];
    dressImageView.image = [UIImage imageNamed:@"itemTitle.png"];
    [self.scrollView addSubview:dressImageView];
    
    UIImageView *dressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 40,40)];
    dressIcon.image = [UIImage imageNamed:@"穿衣指数.png"];
    [dressImageView addSubview:dressIcon];
    
    UILabel *dressTitle = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 80,15)];
    dressTitle.backgroundColor = [UIColor clearColor];
    dressTitle.textColor = [UIColor whiteColor];
    dressTitle.textAlignment = NSTextAlignmentLeft;
    dressTitle.font = [UIFont boldSystemFontOfSize:16];
    dressTitle.text = @"穿衣指数";
    [dressImageView addSubview:dressTitle];
    
    UILabel *dressDesc = [[UILabel alloc] initWithFrame:CGRectMake(240, 15, 80,15)];
    dressDesc.backgroundColor = [UIColor clearColor];
    dressDesc.textColor = [UIColor whiteColor];
    dressDesc.textAlignment = NSTextAlignmentLeft;
    dressDesc.font = [UIFont boldSystemFontOfSize:16];
    dressDesc.text = self.weather._58index;
    [dressImageView addSubview:dressDesc];
    
    UILabel *dressDetail = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300,45)];
    dressDetail.backgroundColor = [UIColor clearColor];
    dressDetail.lineBreakMode = UILineBreakModeWordWrap;
    dressDetail.numberOfLines = 0;
    dressDetail.textColor = [UIColor whiteColor];
    dressDetail.textAlignment = NSTextAlignmentLeft;
    dressDetail.font = [UIFont systemFontOfSize:14];
    dressDetail.text = self.weather._59index_d;
    [dressImageView addSubview:dressDetail];
    
    //紫外线指数
    UIImageView *uvImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 92, self.view.frame.size.width,46)];
    uvImageView.image = [UIImage imageNamed:@"itemTitle.png"];
    [self.scrollView addSubview:uvImageView];
    
    UIImageView *uvIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 40,40)];
    uvIcon.image = [UIImage imageNamed:@"紫外线指数.png"];
    [uvImageView addSubview:uvIcon];
    
    UILabel *uvTitle = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 80,15)];
    uvTitle.backgroundColor = [UIColor clearColor];
    uvTitle.textColor = [UIColor whiteColor];
    uvTitle.textAlignment = NSTextAlignmentLeft;
    uvTitle.font = [UIFont boldSystemFontOfSize:16];
    uvTitle.text = @"紫外线指数";
    [uvImageView addSubview:uvTitle];
    
    UILabel *uvDesc = [[UILabel alloc] initWithFrame:CGRectMake(240, 15, 80,15)];
    uvDesc.backgroundColor = [UIColor clearColor];
    uvDesc.textColor = [UIColor whiteColor];
    uvDesc.textAlignment = NSTextAlignmentLeft;
    uvDesc.font = [UIFont boldSystemFontOfSize:16];
    uvDesc.text = self.weather._62index_uv;
    [uvImageView addSubview:uvDesc];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
