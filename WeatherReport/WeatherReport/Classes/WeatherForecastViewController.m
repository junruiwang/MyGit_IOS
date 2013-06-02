//
//  WeatherForecastViewController.m
//  WeatherReport
//
//  Created by jerry on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "WeatherForecastViewController.h"
#import "ChineseToPinyin.h"
#import "WeatherDayParser.h"
#import "WeatherAWeekParser.h"
#import "CityManagerViewController.h"
#import "SqliteService.h"
#import "Constants.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#define top_scroll_view_tag 100
#define bottom_scroll_view_tag 101
#define bottom_bg_view_tag 102


@interface WeatherForecastViewController ()

@property(nonatomic, strong) UIImage *bgImage;
@property(nonatomic, strong) WeatherDayParser *weatherDayParser;
@property(nonatomic, strong) WeatherAWeekParser *weatherAWeekParser;
@property(nonatomic, strong) CityManagerViewController *cityManagerViewController;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property(nonatomic, strong) SqliteService *sqliteService;
@property(nonatomic, strong) NSDate *locationTime;
@property(nonatomic, strong) ModelWeather *weather;

@end

@implementation WeatherForecastViewController

- (id)init
{
    self = [super init];
    if (self) {
        _sqliteService=[[SqliteService alloc]init];
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
        _cityManagerViewController.delegate = self;
    }
    return _cityManagerViewController;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    ModelWeather *modelWeather = TheAppDelegate.modelWeather;
    [self upCurrentWeatherAfterTwoHour:modelWeather];
}

- (void)upCurrentWeatherAfterTwoHour:(ModelWeather *) modelWeather
{
    if (modelWeather) {
        NSString *upTime = modelWeather._3time;
        upTime = [upTime substringToIndex:[upTime rangeOfString:@":"].location];
        if ([[upTime substringToIndex:1] isEqualToString:@"0"]) {
            upTime = [upTime substringFromIndex:1];
        }
        int upTimeInt = upTime.intValue;
        
        NSDateFormatter *tempformatter = [[NSDateFormatter alloc]init];
        [tempformatter setDateFormat:@"HH:mm"];
        NSDate *timeNow = [NSDate date];
        NSString *currentTime = [tempformatter stringFromDate:timeNow];
        currentTime = [currentTime substringToIndex:[currentTime rangeOfString:@":"].location];
        if ([[currentTime substringToIndex:1] isEqualToString:@"0"]) {
            currentTime = [currentTime substringFromIndex:1];
        }
        int currentTimeInt = currentTime.intValue;
        
        if ((currentTimeInt-upTimeInt) > 1 || (currentTimeInt-upTimeInt) < -1) {
            [self downloadDataForDay:modelWeather._2cityid];
        }
    }
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
    //初始化 ScrollView
    [self loadScrollView];
    //初始化天气数据
    [self initScrollerView];
    //初始化loading控件
    [self initLoadingActivityIndicator];
}

- (void)loadScrollView
{
    self.screenWidth=self.view.frame.size.width;
    float scrollHeight = 412;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        scrollHeight += 88;
    }
    self.screenHeight=scrollHeight;
    
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
    self.scrollView.tag = top_scroll_view_tag;
	self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.delegate =self;
    self.scrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.scrollView];
}

- (void)loadBottomScrollView
{
    float bottomViewHeight = 82;
    
    if (![self.view viewWithTag:bottom_bg_view_tag]) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.screenHeight - bottomViewHeight, self.screenWidth, bottomViewHeight)];
        bottomView.tag = bottom_bg_view_tag;
        
        bottomView.backgroundColor=[UIColor clearColor];
        
        UIImageView *bottonBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, bottomViewHeight)];
        bottonBgImage.image = [UIImage imageNamed:@"todayview_bg.png"];
        [bottomView addSubview:bottonBgImage];
        
        [self.view addSubview:bottomView];
    }
    
    if (![self.view viewWithTag:bottom_scroll_view_tag]) {
        self.bottomScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.screenHeight - bottomViewHeight, self.screenWidth, bottomViewHeight)];
        self.bottomScrollView.tag = bottom_scroll_view_tag;
        self.bottomScrollView.pagingEnabled = YES;
        self.bottomScrollView.showsHorizontalScrollIndicator = NO;
        self.bottomScrollView.showsVerticalScrollIndicator = NO;
        self.bottomScrollView.delegate =self;
        self.bottomScrollView.backgroundColor=[UIColor clearColor];
        [self.view addSubview:self.bottomScrollView];
    }
}

//初始化ScrollerView
-(void)initScrollerView
{
    [self reDrawModelWeatherView];
    
    if (self.remainCityModel != nil && [self.remainCityModel count] > 0) {
        ModelWeather *weather=((ModelWeather *)[self.remainCityModel objectAtIndex:0]);
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        TheAppDelegate.modelWeather = weather;
        [self setCurrentNavigationBarTitle];
    }
}

//初始化加载loading效果
- (void)initLoadingActivityIndicator
{
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.center.x-20, self.view.center.y, 50, 50)];
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:_activityIndicatorView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//定位后如果没有当前城市，下载数据，重新绘制视图
- (void)updateLocationWhenCityNull
{
    NSDate *currentTime = [NSDate date];
    NSTimeInterval intCurrentTime = [currentTime timeIntervalSince1970];
    
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
    }
    
    if (self.locationTime == nil || (intCurrentTime - [self.locationTime timeIntervalSince1970]) > 1800) {
        self.locationTime = [NSDate date];
        
        NSMutableArray *hisvalue=[[NSMutableArray alloc]init];
        
        if (self.remainCityModel != nil && [self.remainCityModel count] > 0) {
            for (int i=0; i<[self.remainCityModel count]; i++) {
                [hisvalue addObject:((ModelWeather *)[self.remainCityModel objectAtIndex:i])._2cityid];
            }
        }
        
        if (![hisvalue containsObject:TheAppDelegate.locationInfo.searchCode]) {
            [self downloadDataForDay:TheAppDelegate.locationInfo.searchCode];
        } else {
            ModelWeather *modelWeather = TheAppDelegate.modelWeather;
            [self upCurrentWeatherAfterTwoHour:modelWeather];
        }
    }
    
}

//刷新数据
- (void)refreshCityBtnClicked :(id)sender
{
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
    }
    self.remainCityModel=[self.sqliteService getWeatherModelArray];
    if ([self.remainCityModel count] > 0) {
        int location=((int)self.scrollView.contentOffset.x)/((int)self.screenWidth);
        
        ModelWeather *weather=((ModelWeather *)[self.remainCityModel objectAtIndex:location]);
        [self upCurrentWeatherAfterTwoHour:weather];
    } else {
        if (TheAppDelegate.locationInfo.searchCode) {
            [self downloadDataForDay:TheAppDelegate.locationInfo.searchCode];
        }
    }
    
}

//临界时间为18:00，设置场景展示
- (BOOL)timeNowIsNight
{
    NSDateFormatter *tempformatter = [[NSDateFormatter alloc]init];
    [tempformatter setDateFormat:@"yyyy-MM-dd"];

    NSDate *timeNow = [NSDate date];
    NSString *tempString = [tempformatter stringFromDate:timeNow];
    
    [tempformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    tempString = [NSString stringWithFormat:@"%@ %@", tempString, @"18:00:00"];
    NSDate *tempDate = [tempformatter dateFromString:tempString];
    
    if ([timeNow compare:tempDate] == NSOrderedAscending) {
        return NO;
    }
    
    return YES;
}

- (void)loadBgImageView
{
    float imageHeight = 412;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        imageHeight += 88;
    }
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imageHeight)];
    self.bgImageView.backgroundColor = [UIColor clearColor];
    self.bgImageView.image = [UIImage imageNamed:@"index-default-bg.jpg"];
    
    [self.view addSubview:self.bgImageView];
    
    UIView *navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    navigationBarView.backgroundColor = [UIColor clearColor];
    
    UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cityButton.frame = CGRectMake(10, 10, 29, 25);
    [cityButton setImage:[UIImage imageNamed:@"country-field.png"] forState:UIControlStateNormal];
    [cityButton addTarget:self action:@selector(addCityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:cityButton];
    
    UIImageView *pixImageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 10, 1, 24)];
    pixImageView.image = [UIImage imageNamed:@"chooseforard_division_shu.png"];
    [navigationBarView addSubview:pixImageView];
    
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 80, 20)];
    self.cityLabel.backgroundColor = [UIColor clearColor];
    self.cityLabel.font = [UIFont boldSystemFontOfSize:20];
    self.cityLabel.textColor = [UIColor whiteColor];
    self.cityLabel.textAlignment = NSTextAlignmentCenter;
    [navigationBarView addSubview:self.cityLabel];
    
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(235, 4, 40, 38);
    [refreshButton setImage:[UIImage imageNamed:@"barbutton-refresh.png"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshCityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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


- (void)downloadDataForDay:(NSString *)searchCode
{
    [self loading];
    if (self.weatherDayParser!= nil) {
        [self.weatherDayParser cancel];
        self.weatherDayParser = nil;
    }
    self.weatherDayParser = [[WeatherDayParser alloc] init];
    self.weatherDayParser.delegate = self;
    
    NSString *resourceAddress = [ServerAddressManager serverAddress:@"query_weather_current_time"];
    self.weatherDayParser.serverAddress = [resourceAddress stringByAppendingFormat:@"%@.html", searchCode];
    
    [self.weatherDayParser start];
}

- (void)downloadDataForWeek:(NSString *)searchCode
{
    if (self.weatherAWeekParser!= nil) {
        [self.weatherAWeekParser cancel];
        self.weatherAWeekParser = nil;
    }
    self.weatherAWeekParser = [[WeatherAWeekParser alloc] init];
    self.weatherAWeekParser.delegate = self;
    
    NSString *resourceAddress = [ServerAddressManager serverAddress:@"query_weather_week_day"];
    self.weatherAWeekParser.serverAddress = [resourceAddress stringByAppendingFormat:@"%@.html", searchCode];
    
    [self.weatherAWeekParser start];
}

//添加城市
- (void)addCityBtnClicked:(id)sender
{
    UINavigationController *nav = [[UINavigationController alloc]
                                   initWithRootViewController:self.cityManagerViewController];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    [self presentModalViewController:nav animated:YES];
}


#pragma mark - BaseParserDelegate
- (void)parser:(BaseParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    NSLog(@"查询一周天气信息发生异常：%@，错误代码：%d", msg, code);
    [self loadingDismiss];
}

- (void)parser:(BaseParser*)parser DidParsedData:(NSDictionary *)data
{
    if ([parser isKindOfClass:[WeatherDayParser class]])
    {
        self.weather = [data valueForKey:@"data"];
        [self downloadDataForWeek:self.weather._2cityid];
        
    } else if ([parser isKindOfClass:[WeatherAWeekParser class]]) {
        ModelWeather *modelWeather = self.weather;
        self.weather = [data valueForKey:@"data"];
        self.weather._1city = modelWeather._1city;
        self.weather._2cityid = modelWeather._2cityid;
        self.weather._3time = modelWeather._3time;
        self.weather._4temp = modelWeather._4temp;
        self.weather._5WD = modelWeather._5WD;
        self.weather._6WS = modelWeather._6WS;
        self.weather._7SD = modelWeather._7SD;
        
        BOOL operateOK = NO;
        //天气信息放入缓存
        if ([self.sqliteService insertModel:self.weather]) {
            //城市信息放入缓存
            LocalCityListManager *localCityListManager = [[LocalCityListManager alloc] init];
            City *city = [[City alloc] init];
            city.province = TheAppDelegate.locationInfo.province;
            city.cityName = self.weather._1city;
            city.searchCode = self.weather._2cityid;
            [localCityListManager insertIntoFaverateWithCity:city];
            operateOK = YES;
        } else if ([self.sqliteService updateWeatherModel:self.weather]) {
            operateOK = YES;
        }
        
        if (operateOK) {
            [self reDrawModelWeatherView];
            for (int j=0; j<[self.remainCityModel count]; j++) {
                ModelWeather *tempWeather = [self.remainCityModel objectAtIndex:j];
                if ([self.weather._2cityid isEqualToString:tempWeather._2cityid]) {
                    TheAppDelegate.modelWeather = self.weather;
                    [self.scrollView setContentOffset:CGPointMake(self.screenWidth*j, 0)];
                    [self setCurrentNavigationBarTitle];
                    break;
                }
            }
        }
        
        [self loadingDismiss];
    }
}

#pragma mark - loadingView
-(void)loading{
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
    }
    [self.activityIndicatorView startAnimating];
}

//隐藏加载动画窗口
- (void) loadingDismiss
{
	[self.activityIndicatorView stopAnimating];
}

//绘制天气视图
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
    int imageNumber = [model._22img1 intValue];
    
    if ([self timeNowIsNight]) {
        if (imageNumber < 2) {
            toImgView.image=[UIImage imageNamed:@"moon-16.png"];
        } else if (imageNumber==3||imageNumber==13||imageNumber==18){
            
        } else if (imageNumber>=29){
            
        } else {
            toImgView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",model._22img1]];
        }
    } else {
        toImgView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",model._22img1]];
    }
    
    [uv addSubview:toImgView];
    
    //今天的天气状况
    UILabel *ToweatherState=[[UILabel alloc] initWithFrame:CGRectMake(131, 124, 169, 36)];
    if (model._16weather1.length > 5) {
        ToweatherState.font=[UIFont fontWithName:@"Helvetica" size:18];
    } else {
        ToweatherState.font=[UIFont fontWithName:@"Helvetica" size:26];
    }
    
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
    ToHumidity.text=[NSString stringWithFormat:@"湿度%@",model._7SD];
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
    ModelWeather *modelWeather = TheAppDelegate.modelWeather;
    self.cityLabel.text = modelWeather._1city;
    int imageNumber = [modelWeather._22img1 intValue];
    
    if ([self timeNowIsNight]) {
        if (imageNumber < 2) {
            self.bgImageView.image = [UIImage imageNamed:@"30-fine-night-bg.jpg"];
        } else if (imageNumber>=2 && imageNumber<=12) {
            self.bgImageView.image = [UIImage imageNamed:@"rain-bg.jpg"];
        } else if (imageNumber>=13 && imageNumber<=20) {
            self.bgImageView.image = [UIImage imageNamed:@"index-default-bg.jpg"];
        } else if (imageNumber>=21 && imageNumber<=25) {
            self.bgImageView.image = [UIImage imageNamed:@"rain-bg.jpg"];
        } else if (imageNumber>=26 && imageNumber<=28) {
            self.bgImageView.image = [UIImage imageNamed:@"index-default-bg.jpg"];
        } else if (imageNumber>=29 && imageNumber<=31) {
            self.bgImageView.image = [UIImage imageNamed:@"index-default-bg.jpg"];
        }
    } else {
        if (imageNumber < 2) {
            self.bgImageView.image = [UIImage imageNamed:@"0-fine-day-bg.jpg"];
        } else if (imageNumber>=2 && imageNumber<=12) {
            self.bgImageView.image = [UIImage imageNamed:@"2-shade-bg.jpg"];
        } else if (imageNumber>=13 && imageNumber<=20) {
            self.bgImageView.image = [UIImage imageNamed:@"index-default-bg.jpg"];
        } else if (imageNumber>=21 && imageNumber<=25) {
            self.bgImageView.image = [UIImage imageNamed:@"2-shade-bg.jpg"];
        } else if (imageNumber>=26 && imageNumber<=28) {
            self.bgImageView.image = [UIImage imageNamed:@"index-default-bg.jpg"];
        } else if (imageNumber>=29 && imageNumber<=31) {
            self.bgImageView.image = [UIImage imageNamed:@"index-default-bg.jpg"];
        }
    }
    
    //初始化一周天气
    [self loadBottomScrollView];
    //绘制底部天气
    [self drawBottomWeekView];
}

- (void)reDrawModelWeatherView
{
    self.remainCityModel=[self.sqliteService getWeatherModelArray];
        
    NSArray *scrollSubViews = [self.scrollView subviews];
    for (UIView *view in scrollSubViews) {
        [view removeFromSuperview];
    }
    
    self.scrollView.contentSize=CGSizeMake(self.screenWidth*[self.remainCityModel count],self.screenHeight);
    for (int j=0; j<[self.remainCityModel count]; j++) {
        UIView *uv=[self DrawScrollerViews:self.screenWidth WithLength:self.screenHeight WithPosition:j];
        [self.scrollView addSubview:uv];
    }
}

- (void)drawBottomWeekView
{
    NSArray *scrollSubViews = [self.bottomScrollView subviews];
    for (UIView *view in scrollSubViews) {
        [view removeFromSuperview];
    }
    int viewCount = 2;
    ModelWeather *model=TheAppDelegate.modelWeather;
    self.bottomScrollView.contentSize = CGSizeMake(self.screenWidth*viewCount,82);
    NSDate *rightNow = [NSDate date];
    UIView *page_1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.screenWidth, 82)];
    
    UIImageView *imageView_1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 40, 40)];
    imageView_1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",model._22img1]];
    [page_1 addSubview:imageView_1];
    
    UILabel *dayByWeek_1 = [[UILabel alloc] initWithFrame:CGRectMake(53, 12, 31, 19)];
    dayByWeek_1.backgroundColor = [UIColor clearColor];
    dayByWeek_1.textColor = [UIColor whiteColor];
    dayByWeek_1.textAlignment = NSTextAlignmentLeft;
    dayByWeek_1.font = [UIFont systemFontOfSize:15];
    dayByWeek_1.text = @"今天";
    [page_1 addSubview:dayByWeek_1];
    
    UILabel *temp_1 = [[UILabel alloc] initWithFrame:CGRectMake(49, 33, 54, 19)];
    temp_1.backgroundColor = [UIColor clearColor];
    temp_1.textColor = [UIColor whiteColor];
    temp_1.textAlignment = NSTextAlignmentLeft;
    temp_1.font = [UIFont systemFontOfSize:15];
    temp_1.text = [self convertTemp:model._10temp1];
    [page_1 addSubview:temp_1];
    
    UIView *weatherView1 = [[UIView alloc] initWithFrame:CGRectMake(5, 57, 93, 21)];
    weatherView1.backgroundColor = [UIColor clearColor];
    weatherView1.clipsToBounds = YES;
    
    UILabel *weather1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 93, 21)];
    weather1.backgroundColor = [UIColor clearColor];
    weather1.textColor = [UIColor whiteColor];
    weather1.textAlignment = NSTextAlignmentCenter;
    weather1.font = [UIFont systemFontOfSize:15];
    weather1.text = model._16weather1;
    [self scrollAnimationLabel:weather1];
    
    [weatherView1 addSubview:weather1];
    [page_1 addSubview:weatherView1];
    
    UIImageView *sepImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(102, 0, 2, 82)];
    sepImageView1.image = [UIImage imageNamed:@"periphery_bottom_separateline.png"];
    [page_1 addSubview:sepImageView1];
    
    //-------------------------------
    
    UIImageView *imageView_2 = [[UIImageView alloc] initWithFrame:CGRectMake(112, 8, 40, 40)];
    imageView_2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",model._24img3]];
    [page_1 addSubview:imageView_2];
    
    UILabel *dayByWeek_2 = [[UILabel alloc] initWithFrame:CGRectMake(163, 12, 31, 19)];
    dayByWeek_2.backgroundColor = [UIColor clearColor];
    dayByWeek_2.textColor = [UIColor whiteColor];
    dayByWeek_2.textAlignment = NSTextAlignmentLeft;
    dayByWeek_2.font = [UIFont systemFontOfSize:15];
    dayByWeek_2.text = [self getCNWeek:[rightNow dateByAddingTimeInterval:1*24*60*60]];
    [page_1 addSubview:dayByWeek_2];
    
    UILabel *temp_2 = [[UILabel alloc] initWithFrame:CGRectMake(159, 33, 54, 19)];
    temp_2.backgroundColor = [UIColor clearColor];
    temp_2.textColor = [UIColor whiteColor];
    temp_2.textAlignment = NSTextAlignmentLeft;
    temp_2.font = [UIFont systemFontOfSize:15];
    temp_2.text = [self convertTemp:model._11temp2];
    [page_1 addSubview:temp_2];
    
    UIView *weatherView2 = [[UIView alloc] initWithFrame:CGRectMake(5+109, 57, 93, 21)];
    weatherView2.backgroundColor = [UIColor clearColor];
    weatherView2.clipsToBounds = YES;
    
    UILabel *weather2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 93, 21)];
    weather2.backgroundColor = [UIColor clearColor];
    weather2.textColor = [UIColor whiteColor];
    weather2.textAlignment = NSTextAlignmentCenter;
    weather2.font = [UIFont systemFontOfSize:15];
    weather2.text = model._17weather2;
    [self scrollAnimationLabel:weather2];
    [weatherView2 addSubview:weather2];
    [page_1 addSubview:weatherView2];
    
    UIImageView *sepImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(212, 0, 2, 82)];
    sepImageView2.image = [UIImage imageNamed:@"periphery_bottom_separateline.png"];
    [page_1 addSubview:sepImageView2];
    
    //-------------------------------
    
    UIImageView *imageView_3 = [[UIImageView alloc] initWithFrame:CGRectMake(220, 8, 40, 40)];
    imageView_3.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",model._26img5]];
    [page_1 addSubview:imageView_3];
    
    UILabel *dayByWeek_3 = [[UILabel alloc] initWithFrame:CGRectMake(272, 12, 31, 19)];
    dayByWeek_3.backgroundColor = [UIColor clearColor];
    dayByWeek_3.textColor = [UIColor whiteColor];
    dayByWeek_3.textAlignment = NSTextAlignmentLeft;
    dayByWeek_3.font = [UIFont systemFontOfSize:15];
    dayByWeek_3.text = [self getCNWeek:[rightNow dateByAddingTimeInterval:2*24*60*60]];
    [page_1 addSubview:dayByWeek_3];
    
    UILabel *temp_3 = [[UILabel alloc] initWithFrame:CGRectMake(268, 33, 54, 19)];
    temp_3.backgroundColor = [UIColor clearColor];
    temp_3.textColor = [UIColor whiteColor];
    temp_3.textAlignment = NSTextAlignmentLeft;
    temp_3.font = [UIFont systemFontOfSize:15];
    temp_3.text = [self convertTemp:model._12temp3];
    [page_1 addSubview:temp_3];
    
    UIView *weatherView3 = [[UIView alloc] initWithFrame:CGRectMake(5+221, 57, 93, 21)];
    weatherView3.backgroundColor = [UIColor clearColor];
    weatherView3.clipsToBounds = YES;
    
    UILabel *weather3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 93, 21)];
    weather3.backgroundColor = [UIColor clearColor];
    weather3.textColor = [UIColor whiteColor];
    weather3.textAlignment = NSTextAlignmentCenter;
    weather3.font = [UIFont systemFontOfSize:15];
    weather3.text = model._18weather3;
    [self scrollAnimationLabel:weather3];
    [weatherView3 addSubview:weather3];
    [page_1 addSubview:weatherView3];
    
    UIImageView *sepImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(319, 0, 2, 82)];
    sepImageView3.image = [UIImage imageNamed:@"periphery_bottom_separateline.png"];
    [page_1 addSubview:sepImageView3];

    
    UIView *page_2=[[UIView alloc]initWithFrame:CGRectMake(self.screenWidth, 0, self.screenWidth, 82)];
    
    UIImageView *imageView_4 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 40, 40)];
    imageView_4.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",model._28img7]];
    [page_2 addSubview:imageView_4];
    
    UILabel *dayByWeek_4 = [[UILabel alloc] initWithFrame:CGRectMake(53, 12, 31, 19)];
    dayByWeek_4.backgroundColor = [UIColor clearColor];
    dayByWeek_4.textColor = [UIColor whiteColor];
    dayByWeek_4.textAlignment = NSTextAlignmentLeft;
    dayByWeek_4.font = [UIFont systemFontOfSize:15];
    dayByWeek_4.text = [self getCNWeek:[rightNow dateByAddingTimeInterval:3*24*60*60]];
    [page_2 addSubview:dayByWeek_4];
    
    UILabel *temp_4 = [[UILabel alloc] initWithFrame:CGRectMake(49, 33, 54, 19)];
    temp_4.backgroundColor = [UIColor clearColor];
    temp_4.textColor = [UIColor whiteColor];
    temp_4.textAlignment = NSTextAlignmentLeft;
    temp_4.font = [UIFont systemFontOfSize:15];
    temp_4.text = [self convertTemp:model._13temp4];
    [page_2 addSubview:temp_4];
    
    UIView *weatherView4 = [[UIView alloc] initWithFrame:CGRectMake(5, 57, 93, 21)];
    weatherView4.backgroundColor = [UIColor clearColor];
    weatherView4.clipsToBounds = YES;
    
    UILabel *weather4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 93, 21)];
    weather4.backgroundColor = [UIColor clearColor];
    weather4.textColor = [UIColor whiteColor];
    weather4.textAlignment = NSTextAlignmentCenter;
    weather4.font = [UIFont systemFontOfSize:15];
    weather4.text = model._19weather4;
    [self scrollAnimationLabel:weather4];
    
    [weatherView4 addSubview:weather4];
    [page_2 addSubview:weatherView4];
    
    UIImageView *sepImageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(102, 0, 2, 82)];
    sepImageView4.image = [UIImage imageNamed:@"periphery_bottom_separateline.png"];
    [page_2 addSubview:sepImageView4];
    
    //-------------------------------
    
    UIImageView *imageView_5 = [[UIImageView alloc] initWithFrame:CGRectMake(112, 8, 40, 40)];
    imageView_5.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",model._30img9]];
    [page_2 addSubview:imageView_5];
    
    UILabel *dayByWeek_5 = [[UILabel alloc] initWithFrame:CGRectMake(163, 12, 31, 19)];
    dayByWeek_5.backgroundColor = [UIColor clearColor];
    dayByWeek_5.textColor = [UIColor whiteColor];
    dayByWeek_5.textAlignment = NSTextAlignmentLeft;
    dayByWeek_5.font = [UIFont systemFontOfSize:15];
    dayByWeek_5.text = [self getCNWeek:[rightNow dateByAddingTimeInterval:4*24*60*60]];
    [page_2 addSubview:dayByWeek_5];
    
    UILabel *temp_5 = [[UILabel alloc] initWithFrame:CGRectMake(159, 33, 54, 19)];
    temp_5.backgroundColor = [UIColor clearColor];
    temp_5.textColor = [UIColor whiteColor];
    temp_5.textAlignment = NSTextAlignmentLeft;
    temp_5.font = [UIFont systemFontOfSize:15];
    temp_5.text = [self convertTemp:model._14temp5];
    [page_2 addSubview:temp_5];
    
    UIView *weatherView5 = [[UIView alloc] initWithFrame:CGRectMake(5+109, 57, 93, 21)];
    weatherView5.backgroundColor = [UIColor clearColor];
    weatherView5.clipsToBounds = YES;
    
    UILabel *weather5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 93, 21)];
    weather5.backgroundColor = [UIColor clearColor];
    weather5.textColor = [UIColor whiteColor];
    weather5.textAlignment = NSTextAlignmentCenter;
    weather5.font = [UIFont systemFontOfSize:15];
    weather5.text = model._20weather5;
    [self scrollAnimationLabel:weather5];
    [weatherView5 addSubview:weather5];
    [page_2 addSubview:weatherView5];
    
    UIImageView *sepImageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(212, 0, 2, 82)];
    sepImageView5.image = [UIImage imageNamed:@"periphery_bottom_separateline.png"];
    [page_2 addSubview:sepImageView5];
    
    //-------------------------------
    
    UIImageView *imageView_6 = [[UIImageView alloc] initWithFrame:CGRectMake(220, 8, 40, 40)];
    imageView_6.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",model._32img11]];
    [page_2 addSubview:imageView_6];
    
    UILabel *dayByWeek_6 = [[UILabel alloc] initWithFrame:CGRectMake(272, 12, 31, 19)];
    dayByWeek_6.backgroundColor = [UIColor clearColor];
    dayByWeek_6.textColor = [UIColor whiteColor];
    dayByWeek_6.textAlignment = NSTextAlignmentLeft;
    dayByWeek_6.font = [UIFont systemFontOfSize:15];
    dayByWeek_6.text = [self getCNWeek:[rightNow dateByAddingTimeInterval:5*24*60*60]];
    [page_2 addSubview:dayByWeek_6];
    
    UILabel *temp_6 = [[UILabel alloc] initWithFrame:CGRectMake(268, 33, 54, 19)];
    temp_6.backgroundColor = [UIColor clearColor];
    temp_6.textColor = [UIColor whiteColor];
    temp_6.textAlignment = NSTextAlignmentLeft;
    temp_6.font = [UIFont systemFontOfSize:15];
    temp_6.text = [self convertTemp:model._15temp6];
    [page_2 addSubview:temp_6];
    
    UIView *weatherView6 = [[UIView alloc] initWithFrame:CGRectMake(5+221, 57, 93, 21)];
    weatherView6.backgroundColor = [UIColor clearColor];
    weatherView6.clipsToBounds = YES;
    
    UILabel *weather6 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 93, 21)];
    weather6.backgroundColor = [UIColor clearColor];
    weather6.textColor = [UIColor whiteColor];
    weather6.textAlignment = NSTextAlignmentCenter;
    weather6.font = [UIFont systemFontOfSize:15];
    weather6.text = model._21weather6;
    [self scrollAnimationLabel:weather6];
    [weatherView6 addSubview:weather6];
    [page_2 addSubview:weatherView6];
    
    [self.bottomScrollView addSubview:page_1];
    [self.bottomScrollView addSubview:page_2];
}

- (NSString *)convertTemp:(NSString *) temp
{
    if (temp != nil && ![temp isEqualToString:@""]) {
        NSArray *tempArray = [temp componentsSeparatedByString:@"~"];
        NSString *temp1 = tempArray[0];
        NSString *temp2 = tempArray[1];
        NSRange range1 = [temp1 rangeOfString:@"℃"];
        NSRange range2 = [temp2 rangeOfString:@"℃"];
        
        return [NSString stringWithFormat:@"%@°/%@°",[temp1 substringToIndex:(range1.location)],[temp2 substringToIndex:(range2.location)]];
    }
     return @"";
}

- (NSString *)getCNWeek:(NSDate *)nsDate
{
    const unsigned int weekday = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:nsDate];
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

- (void)scrollAnimationLabel:(UILabel *)weatherLabel
{
    if (weatherLabel.text.length > 6) {
        [weatherLabel sizeToFit];
    }
    
    CGFloat width = weatherLabel.frame.size.width;
    CGFloat actualWidth = 93;
    if (width > actualWidth)
    {
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
        CGFloat totalTime = (width - actualWidth)/25 + 3;
        animation.duration = totalTime;
        animation.fillMode = kCAFillModeForwards;
        animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:width / 2],
                            [NSNumber numberWithFloat:width / 2],
                            [NSNumber numberWithFloat:actualWidth - width / 2],
                            [NSNumber numberWithFloat:actualWidth - width / 2],
                            [NSNumber numberWithFloat:width / 2], nil];
        animation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                              [NSNumber numberWithFloat:1/totalTime],
                              [NSNumber numberWithFloat:1/totalTime + ((totalTime - 2) / (totalTime * 2))],
                              [NSNumber numberWithFloat:2/totalTime + ((totalTime - 2) / (totalTime * 2))],
                              [NSNumber numberWithFloat:1.0], nil];
        animation.removedOnCompletion = NO;
        animation.repeatCount = HUGE_VALF;  //forever
        [weatherLabel.layer addAnimation:animation forKey:nil];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender.tag == top_scroll_view_tag) {
        int location=((int)sender.contentOffset.x)/((int)self.screenWidth);
        
        if (location == 0) {
            if (sender.contentOffset.x <= 0) {
                [sender setContentOffset:CGPointMake(0, sender.contentOffset.y) animated:NO];
            }
        }
        
        if ((location + 1) == self.remainCityModel.count) {
            if (sender.contentOffset.x > 320*location) {
                [sender setContentOffset:CGPointMake(320*location, sender.contentOffset.y) animated:NO];
            }
        }
        
    } else if (sender.tag == bottom_scroll_view_tag) {
        int location=((int)sender.contentOffset.x)/((int)self.screenWidth);
        if (location == 0) {
            if (sender.contentOffset.x <= 0) {
                [sender setContentOffset:CGPointMake(0, sender.contentOffset.y) animated:NO];
            }
        } else if (location == 1) {
            if (sender.contentOffset.x > 320) {
                [sender setContentOffset:CGPointMake(320, sender.contentOffset.y) animated:NO];
            }
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    if (scrollView.tag == top_scroll_view_tag) {
        if (self.remainCityModel != nil && [self.remainCityModel count] > 0) {
            int location=((int)self.scrollView.contentOffset.x)/((int)self.screenWidth);
            ModelWeather *weather=((ModelWeather *)[self.remainCityModel objectAtIndex:location]);
            
            //判定是否需要更新
            NSString *upTime = weather._3time;
            upTime = [upTime substringToIndex:[upTime rangeOfString:@":"].location];
            if ([[upTime substringToIndex:1] isEqualToString:@"0"]) {
                upTime = [upTime substringFromIndex:1];
            }
            int upTimeInt = upTime.intValue;
            
            NSDateFormatter *tempformatter = [[NSDateFormatter alloc]init];
            [tempformatter setDateFormat:@"HH:mm"];
            NSDate *timeNow = [NSDate date];
            NSString *currentTime = [tempformatter stringFromDate:timeNow];
            currentTime = [currentTime substringToIndex:[currentTime rangeOfString:@":"].location];
            if ([[currentTime substringToIndex:1] isEqualToString:@"0"]) {
                currentTime = [currentTime substringFromIndex:1];
            }
            int currentTimeInt = currentTime.intValue;
            
            if ((currentTimeInt-upTimeInt) > 1 || (currentTimeInt-upTimeInt) < -1) {
                int location=((int)self.scrollView.contentOffset.x)/((int)self.screenWidth);
                ModelWeather *weather=((ModelWeather *)[self.remainCityModel objectAtIndex:location]);
                [self downloadDataForDay:weather._2cityid];
            } else {
                TheAppDelegate.modelWeather = weather;
                [self setCurrentNavigationBarTitle];
            }
        }
    }
}

#pragma mark - CityManagerControllerDelegate
- (void)citySelected
{
    [self reDrawModelWeatherView];
    if ([self.remainCityModel count] == 0) {
        [self.bottomScrollView removeFromSuperview];
        [[self.view viewWithTag:bottom_bg_view_tag] removeFromSuperview];
        self.bgImageView.image = [UIImage imageNamed:@"index-default-bg.jpg"];
        
        TheAppDelegate.modelWeather = nil;
        self.cityLabel.text = nil;
    } else {
        BOOL isExit = NO;
        for (int i=0; i<[self.remainCityModel count]; i++) {
            ModelWeather *weather=[self.remainCityModel objectAtIndex:i];
            if ([TheAppDelegate.modelWeather._2cityid isEqualToString:weather._2cityid]) {
                [self.scrollView setContentOffset:CGPointMake(self.screenWidth*i, 0)];
                [self setCurrentNavigationBarTitle];
                isExit = YES;
                break;
            }
        }
        if (!isExit) {
            TheAppDelegate.modelWeather = [self.remainCityModel objectAtIndex:0];
            [self.scrollView setContentOffset:CGPointMake(0, 0)];
            [self setCurrentNavigationBarTitle];
        }
    }
}

@end
