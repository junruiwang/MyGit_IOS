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
#import "CityManagerViewController.h"
#import "SqliteService.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface IndexViewController ()

@property(nonatomic, strong) UIImage *bgImage;
@property(nonatomic, strong) WeatherWeekDayParser *weatherWeekDayParser;
@property(nonatomic, strong) CityManagerViewController *cityManagerViewController;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation IndexViewController

- (id)init
{
    self = [super init];
    if (self) {
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationWhenCityNull) name:@"locationCurrentFinished" object:nil];
    }
    return self;
}

- (CityManagerViewController *)cityManagerViewController
{
    if (!_cityManagerViewController)
    {
        _cityManagerViewController = [[CityManagerViewController alloc] initWithNibName:@"CityManagerViewController" bundle:nil];
    }
    return _cityManagerViewController;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initScrollerView];
    [self setCurrentNavigationBarTitle];
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
    
    //初始化
    self.screenWidth=self.view.frame.size.width;
    float scrollHeight = 412;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        scrollHeight += 88;
    }
    self.screenHeight=scrollHeight;
    
    //新线程下载一周天气
    [NSThread detachNewThreadSelector:@selector(downloadData) toTarget:self withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//定位后如果没有当前城市，下载数据，重新绘制视图
- (void)updateLocationWhenCityNull
{
    self.cityLabel.text = TheAppDelegate.locationInfo.cityName;
    SqliteService *sql=[[SqliteService alloc]init];
    NSMutableArray *tempdata=[sql getWeatherModelArray];
    
    NSMutableArray *hisvalue=[[NSMutableArray alloc]init];
    for (int i=0; i<[tempdata count]; i++) {
        [hisvalue addObject:((ModelWeather *)[tempdata objectAtIndex:i])._1city];
    }
    
    if (![hisvalue containsObject:TheAppDelegate.locationInfo.cityName]) {
        [self loading];
        [NSThread detachNewThreadSelector:@selector(startTheBackgroundJob:) toTarget:self withObject:TheAppDelegate.locationInfo.searchCode];
    }
}

//刷新数据
- (void)refreshCityBtnClicked :(id)sender
{
    [self loading];
    int location=((int)self.scrollView.contentOffset.x)/((int)self.screenWidth);
    SqliteService *sqlservice=[[SqliteService alloc]init];
    self.remainCityModel=[sqlservice getWeatherModelArray];
    ModelWeather *weather=((ModelWeather *)[self.remainCityModel objectAtIndex:location]);
    
    [NSThread detachNewThreadSelector:@selector(startUPTheBackgroudJob:) toTarget:self withObject:weather._2cityid];
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
    [cityButton addTarget:self action:@selector(addCityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:cityButton];
    
    UIImageView *pixImageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 10, 1, 24)];
    pixImageView.image = [UIImage imageNamed:@"chooseforard_division_shu.png"];
    [navigationBarView addSubview:pixImageView];
    
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, 40, 20)];
    self.cityLabel.backgroundColor = [UIColor clearColor];
    self.cityLabel.font = [UIFont boldSystemFontOfSize:20];
    self.cityLabel.textColor = [UIColor whiteColor];
    self.cityLabel.textAlignment = NSTextAlignmentCenter;
    [navigationBarView addSubview:self.cityLabel];
    
    
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
                                   initWithRootViewController:self.cityManagerViewController];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    [self presentModalViewController:nav animated:YES];
}

//后台下载城市天气
- (void)startTheBackgroundJob:(NSString *)searchCode
{
    if (self.weatherWeekDayParser!= nil) {
        [self.weatherWeekDayParser cancel];
        self.weatherWeekDayParser = nil;
    }
    self.weatherWeekDayParser = [[WeatherWeekDayParser alloc] init];
    self.weatherWeekDayParser.delegate = self;
    
    ModelWeather *weather = [[ModelWeather alloc] init];
    NSString *resourceAddress = [ServerAddressManager serverAddress:@"query_weather_current_time"];
    self.weatherWeekDayParser.serverAddress = [resourceAddress stringByAppendingFormat:@"%@.html", searchCode];
    [self.weatherWeekDayParser startSynchronous:weather];
    resourceAddress = [ServerAddressManager serverAddress:@"query_weather_week_day"];
    self.weatherWeekDayParser.serverAddress = [resourceAddress stringByAppendingFormat:@"%@.html", searchCode];
    [self.weatherWeekDayParser startSynchronous:weather];
    [self addWeatherResoure:weather];
}

//后台更新城市天气
-(void)startUPTheBackgroudJob:(NSString *)searchCode
{
    if (self.weatherWeekDayParser!= nil) {
        [self.weatherWeekDayParser cancel];
        self.weatherWeekDayParser = nil;
    }
    self.weatherWeekDayParser = [[WeatherWeekDayParser alloc] init];
    self.weatherWeekDayParser.delegate = self;
    
    ModelWeather *weather = [[ModelWeather alloc] init];
    NSString *resourceAddress = [ServerAddressManager serverAddress:@"query_weather_current_time"];
    self.weatherWeekDayParser.serverAddress = [resourceAddress stringByAppendingFormat:@"%@.html", searchCode];
    [self.weatherWeekDayParser startSynchronous:weather];
    resourceAddress = [ServerAddressManager serverAddress:@"query_weather_week_day"];
    self.weatherWeekDayParser.serverAddress = [resourceAddress stringByAppendingFormat:@"%@.html", searchCode];
    [self.weatherWeekDayParser startSynchronous:weather];
    
    [self upWeatherResource:weather];
}


//增加一个城市的天气模型
- (void)addWeatherResoure:(ModelWeather *)model
{
    SqliteService *sqlservice=[[SqliteService alloc]init];
    [sqlservice insertModel:model];
    
    self.remainCityModel=[sqlservice getWeatherModelArray];
    for (int i=0; i<[self.remainCityModel count]-1; i++) {
        [(UIView *)[self.scrollView viewWithTag:1000+i] removeFromSuperview];
    }
    
    self.scrollView.contentSize=CGSizeMake(self.screenWidth*[self.remainCityModel count],self.screenHeight);
    
    for (int j=0; j<[self.remainCityModel count]; j++) {
        UIView *uv=[self DrawScrollerViews:self.screenWidth WithLength:self.screenHeight WithPosition:j];
        [self.scrollView addSubview:uv];
    }
    [self.scrollView setContentOffset:CGPointMake(self.screenWidth*([self.remainCityModel count]-1), 0)];
    [self loadingDismiss];
}


//更新一个城市的天气
- (void)upWeatherResource:(ModelWeather *)model
{
    SqliteService *sqlservice=[[SqliteService alloc]init];
    [sqlservice updateWeatherModel:model];

    self.remainCityModel=[sqlservice getWeatherModelArray];
    for (int i=0; i<[self.remainCityModel count]; i++) {
        [(UIView *)[self.scrollView viewWithTag:1000+i] removeFromSuperview];
    }
    self.scrollView.contentSize=CGSizeMake(self.screenWidth*[self.remainCityModel count],self.screenHeight);
    for (int j=0; j<[self.remainCityModel count]; j++) {
        UIView *uv=[self DrawScrollerViews:self.screenWidth WithLength:self.screenHeight WithPosition:j];
        [self.scrollView addSubview:uv];
    }
    [self loadingDismiss];
}

#pragma mark - BaseJSONParserDelegate
- (void)parser:(BaseParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    NSLog(@"查询一周天气信息发生异常：%@，错误代码：%d", msg, code);
}

- (void)parser:(BaseParser*)parser DidParsedData:(NSDictionary *)data
{
    
}

#pragma mark - loadingView
-(void)loading{
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.center.x-20, self.view.center.y, 50, 50)];
    _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    _activityIndicatorView.hidesWhenStopped = YES;
    [_activityIndicatorView startAnimating];
    [self.view addSubview:_activityIndicatorView];
    
}
//隐藏加载动画窗口
- (void) loadingDismiss
{
	[_activityIndicatorView stopAnimating];
}

//初始化ScrollerView
-(void)initScrollerView
{
    SqliteService *sql=[[SqliteService alloc]init];
    self.remainCityModel = [sql getWeatherModelArray];
    
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
	self.scrollView.pagingEnabled = YES;
	self.scrollView.delegate =self;
    self.scrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    self.scrollView.contentSize=CGSizeMake(self.screenWidth*[self.remainCityModel count],self.screenHeight);
    for (int i=0; i<[self.remainCityModel count]; i++) {
        UIView *uv=[self DrawScrollerViews:self.screenWidth WithLength:self.screenHeight WithPosition:i];
        [self.scrollView addSubview:uv];
    }
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}

-(UIView *)DrawScrollerViews:(float)width WithLength :(float)height WithPosition :(NSInteger)position
{
    //天气模型
    ModelWeather *model=[self.remainCityModel objectAtIndex:position];
    /*
     数据可视化过程
     */
    UIView *uv=[[UIView alloc]initWithFrame:CGRectMake(width*position, 0, width, height)];
    uv.tag=1000+position;
    
    //今天天气的图片资源
    UIImageView *toImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
    toImgView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",model._22img1]];
    [uv addSubview:toImgView];
    
    //今天的天气状况
    UILabel *ToweatherState=[[UILabel alloc] initWithFrame:CGRectMake(131, 124, 169, 36)];
    ToweatherState.font=[UIFont fontWithName:@"Helvetica" size:26];
    ToweatherState.text=model._16weather1;
    ToweatherState.backgroundColor=[UIColor clearColor];
    ToweatherState.textColor=[UIColor whiteColor];
    ToweatherState.textAlignment = NSTextAlignmentRight;
    [uv addSubview:ToweatherState];
    
    //今天温度
    UILabel *ToTemp=[[UILabel alloc] initWithFrame:CGRectMake(200, 57, 100, 65)];
    ToTemp.font=[UIFont fontWithName:@"Helvetica" size:50];
    ToTemp.text=[NSString stringWithFormat:@"%@°",model._4temp];
    ToTemp.backgroundColor=[UIColor clearColor];
    ToTemp.textColor=[UIColor whiteColor];
    ToTemp.textAlignment = NSTextAlignmentRight;
    [uv addSubview:ToTemp];
    
    //今天温度范围
    UILabel *ToDistinceTemp=[[UILabel alloc] initWithFrame:CGRectMake(142, 163, 93, 25)];
    ToDistinceTemp.font=[UIFont fontWithName:@"Helvetica" size:15];
    ToDistinceTemp.text=[NSString stringWithFormat:@"%@°",model._10temp1];
    ToDistinceTemp.backgroundColor=[UIColor clearColor];
    ToDistinceTemp.textColor=[UIColor whiteColor];
    ToDistinceTemp.textAlignment = NSTextAlignmentLeft;
    [uv addSubview:ToDistinceTemp];
    
    //图片
    UIImageView *seplitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 160, 280, 2)];
    seplitImageView.image = [[UIImage imageNamed:@"dotted_line.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:1];
    [uv addSubview:seplitImageView];
    
    //今天湿度
    UILabel *ToHumidity=[[UILabel alloc] initWithFrame:CGRectMake(142, 188, 70, 19)];
    ToHumidity.font=[UIFont fontWithName:@"Helvetica" size:15];
    ToHumidity.text=[NSString stringWithFormat:@"湿度%@°",model._7SD];
    ToHumidity.backgroundColor=[UIColor clearColor];
    ToHumidity.textColor=[UIColor whiteColor];
    ToHumidity.textAlignment = NSTextAlignmentLeft;
    [uv addSubview:ToHumidity];

    //今天实况风向风速
    UILabel *ToWind=[[UILabel alloc] initWithFrame:CGRectMake(209, 187, 97, 21)];
    ToWind.font=[UIFont fontWithName:@"Helvetica" size:15];
    ToWind.text=[NSString stringWithFormat:@"%@%@",model._5WD,model._6WS];
    ToWind.backgroundColor=[UIColor clearColor];
    ToWind.textColor=[UIColor whiteColor];
    ToWind.textAlignment = NSTextAlignmentLeft;
    [uv addSubview:ToWind];
    
    //显示日期
    UILabel *Today=[[UILabel alloc] initWithFrame:CGRectMake(142, 209, 104, 25)];
    Today.font=[UIFont fontWithName:@"Helvetica" size:15];
    Today.text=[NSString stringWithFormat:@"%@",model._8date_y];
    Today.backgroundColor=[UIColor clearColor];
    Today.textColor=[UIColor whiteColor];
    Today.textAlignment = NSTextAlignmentLeft;
    [uv addSubview:Today];
    
    //显示星期几
    UILabel *ToWeekDay=[[UILabel alloc] initWithFrame:CGRectMake(252, 212, 46, 19)];
    ToWeekDay.font=[UIFont fontWithName:@"Helvetica" size:15];
    ToWeekDay.text=[NSString stringWithFormat:@"%@",model._9week];
    ToWeekDay.backgroundColor=[UIColor clearColor];
    ToWeekDay.textColor=[UIColor whiteColor];
    ToWeekDay.textAlignment = NSTextAlignmentLeft;
    [uv addSubview:ToWeekDay];
      
    //天气更新时间
    UILabel *updateTime=[[UILabel alloc] initWithFrame:CGRectMake(142, 235, 115, 19)];
    updateTime.font=[UIFont fontWithName:@"Helvetica" size:13];
    updateTime.text=[NSString stringWithFormat:@"[今天 %@ 发布]",model._3time];
    updateTime.backgroundColor=[UIColor clearColor];
    updateTime.textColor=[UIColor whiteColor];
    updateTime.textAlignment = NSTextAlignmentLeft;
    [uv addSubview:updateTime];
    
    return uv;
}

- (void)setCurrentNavigationBarTitle
{
    int location=((int)self.scrollView.contentOffset.x)/((int)self.screenWidth);
    if (location > 0) {
        ModelWeather *weather=((ModelWeather *)[self.remainCityModel objectAtIndex:location]);
        self.cityLabel.text = weather._1city;
    }
}

@end
