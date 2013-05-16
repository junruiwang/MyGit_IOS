//
//  IndexViewController.m
//  WeatherReport
//
//  Created by jerry on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "IndexViewController.h"
#import "ChineseToPinyin.h"
#import "WeatherWeekDayParser.h"

@interface IndexViewController ()

@property(nonatomic, strong) UIImage *bgImage;
@property(nonatomic, strong) WeatherWeekDayParser *weatherWeekDayParser;
@property(nonatomic, strong) CityTableListViewController *cityTableListViewController;

@end

@implementation IndexViewController

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

- (CityTableListViewController *)cityTableListViewController
{
    if (!_cityTableListViewController)
    {
        _cityTableListViewController = [[CityTableListViewController alloc] init];
        _cityTableListViewController.delegate = self;
    }
    return _cityTableListViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 背景设置为黑色
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
    // 透明度设置为0.3
    self.navigationController.navigationBar.alpha = 0.300;
    // 设置为半透明
    self.navigationController.navigationBar.translucent = YES;
    
    //加载背景图片
    [self loadBgImageView];
    //[self initalToolbar];
    //新线程下载一周天气
    [NSThread detachNewThreadSelector:@selector(downloadData) toTarget:self withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadBgImageView
{
    float imageHeight = 412;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        imageHeight += 88;
    }
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imageHeight)];
    bgImageView.backgroundColor = [UIColor clearColor];
    bgImageView.image = [UIImage imageNamed:@"load_bg1.png"];
    [self.view addSubview:bgImageView];
    
    UIView *navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    navigationBarView.backgroundColor = [UIColor clearColor];
    
    UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cityButton.frame = CGRectMake(10, 10, 25, 22);
    [cityButton setImage:[UIImage imageNamed:@"country-field.png"] forState:UIControlStateNormal];
    [navigationBarView addSubview:cityButton];
    
    UIImageView *pixImageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 10, 1, 24)];
    pixImageView.image = [UIImage imageNamed:@"chooseforard_division_shu.png"];
    [navigationBarView addSubview:pixImageView];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, 40, 20)];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.font = [UIFont boldSystemFontOfSize:20];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    
    cityLabel.text = @"上海";
    [navigationBarView addSubview:cityLabel];
    
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(235, 4, 38, 36);
    [refreshButton setImage:[UIImage imageNamed:@"barbutton-refresh.png"] forState:UIControlStateNormal];
    [navigationBarView addSubview:refreshButton];
    
    UIImageView *pixImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(276, 10, 1, 24)];
    pixImageView2.image = [UIImage imageNamed:@"chooseforard_division_shu.png"];
    [navigationBarView addSubview:pixImageView2];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(280, 4, 36, 36);
    [shareButton setImage:[UIImage imageNamed:@"forecast-forward-btn.png"] forState:UIControlStateNormal];
    [navigationBarView addSubview:shareButton];
    
    [self.navigationController.view addSubview:navigationBarView];
}

//初始化工具条
- (void)initalToolbar
{
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 110, 45)];
    [tools setBarStyle:UIBarStyleBlack];
    
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
    
    UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithTitle:@"更新" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshCityBtnClicked:)];
	UIBarButtonItem *btndelete = [[UIBarButtonItem alloc]
                                  initWithTitle:@"管理" style:UIBarButtonItemStyleBordered target:self action:@selector(removeCityBtnClicked:)];
    [buttons addObject:btnRefresh];
	[buttons addObject:btndelete];
	[tools setItems:buttons animated:NO];

    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]
										   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCityBtnClicked:)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:tools];
}

- (void)downloadData
{
    if (self.weatherWeekDayParser != nil) {
        [self.weatherWeekDayParser cancel];
        self.weatherWeekDayParser = nil;
    }
    self.weatherWeekDayParser = [[WeatherWeekDayParser alloc] init];
    
    NSString *resourceAddress = [ServerAddressManager serverAddress:@"query_weather_week_day"];
    resourceAddress = [resourceAddress stringByAppendingFormat:@"%@.html", @"101201107"];
    
    self.weatherWeekDayParser.serverAddress = resourceAddress;
    self.weatherWeekDayParser.delegate = self;
    [self.weatherWeekDayParser start];
}

//添加城市
- (void)addCityBtnClicked:(id)sender
{
    UINavigationController *nav = [[UINavigationController alloc]
                                   initWithRootViewController:self.cityTableListViewController];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    [self presentModalViewController:nav animated:YES];
}


//选中 所要添加的城市 scorllerview 重绘
- (void)citySelected:(NSString *)cityName;
{
    NSLog(@"城市：%@", cityName);
}

#pragma mark -
#pragma mark BaseJSONParserDelegate
- (void)parser:(BaseParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    NSLog(@"查询一周天气信息发生异常：%@，错误代码：%d", msg, code);
}

- (void)parser:(BaseParser*)parser DidParsedData:(NSDictionary *)data
{
    
}

@end
