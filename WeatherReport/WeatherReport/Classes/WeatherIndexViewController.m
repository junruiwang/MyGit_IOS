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
    self.navigationItem.title = @"今日指数";
    self.trackedViewName = @"今日指数页面";
    float imageHeight = 367;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        imageHeight += 88;
    }
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imageHeight)];
    bgImageView.backgroundColor = [UIColor clearColor];
    bgImageView.image = [UIImage imageNamed:@"trend-tab-bg.jpg"];
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
    self.scrollView.contentSize=CGSizeMake(self.view.frame.size.width,500);
    [self.view addSubview:self.scrollView];
}

- (void)loadWeatherIndexPage
{
    NSArray *scrollSubViews = [self.scrollView subviews];
    for (UIView *view in scrollSubViews) {
        [view removeFromSuperview];
    }
    //穿衣指数
    UIImageView *dressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, self.view.frame.size.width,46)];
    dressImageView.image = [UIImage imageNamed:@"itemTitle.png"];
    [self.scrollView addSubview:dressImageView];
    
    UIImageView *dressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 40,40)];
    dressIcon.image = [UIImage imageNamed:@"chuanyizhishu.png"];
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
    
    UILabel *dressDetail = [[UILabel alloc] initWithFrame:CGRectMake(10, 48, 300,45)];
    dressDetail.backgroundColor = [UIColor clearColor];
    dressDetail.lineBreakMode = UILineBreakModeWordWrap;
    dressDetail.numberOfLines = 0;
    dressDetail.textColor = [UIColor whiteColor];
    dressDetail.textAlignment = NSTextAlignmentLeft;
    dressDetail.font = [UIFont systemFontOfSize:14];
    dressDetail.text = self.weather._59index_d;
    [self.scrollView addSubview:dressDetail];
    
    //紫外线指数
    UIImageView *uvImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 94, self.view.frame.size.width,46)];
    uvImageView.image = [UIImage imageNamed:@"itemTitle.png"];
    [self.scrollView addSubview:uvImageView];
    
    UIImageView *uvIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 40,40)];
    uvIcon.image = [UIImage imageNamed:@"zhiwaixianzhishu.png"];
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
    
    UILabel *uvDetail = [[UILabel alloc] initWithFrame:CGRectMake(10, 145, 300,45)];
    uvDetail.backgroundColor = [UIColor clearColor];
    uvDetail.lineBreakMode = UILineBreakModeWordWrap;
    uvDetail.numberOfLines = 0;
    uvDetail.textColor = [UIColor whiteColor];
    uvDetail.textAlignment = NSTextAlignmentLeft;
    uvDetail.font = [UIFont systemFontOfSize:14];
    uvDetail.text = [self getUvDetailMessage:self.weather._62index_uv];
    [self.scrollView addSubview:uvDetail];
    
    //洗车指数
    UIImageView *xcImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 190, self.view.frame.size.width,46)];
    xcImageView.image = [UIImage imageNamed:@"itemTitle.png"];
    [self.scrollView addSubview:xcImageView];
    
    UIImageView *xcIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 40,40)];
    xcIcon.image = [UIImage imageNamed:@"xichezhishu.png"];
    [xcImageView addSubview:xcIcon];
    
    UILabel *xcTitle = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 80,15)];
    xcTitle.backgroundColor = [UIColor clearColor];
    xcTitle.textColor = [UIColor whiteColor];
    xcTitle.textAlignment = NSTextAlignmentLeft;
    xcTitle.font = [UIFont boldSystemFontOfSize:16];
    xcTitle.text = @"洗车指数";
    [xcImageView addSubview:xcTitle];
    
    UILabel *xcDesc = [[UILabel alloc] initWithFrame:CGRectMake(240, 15, 80,15)];
    xcDesc.backgroundColor = [UIColor clearColor];
    xcDesc.textColor = [UIColor whiteColor];
    xcDesc.textAlignment = NSTextAlignmentLeft;
    xcDesc.font = [UIFont boldSystemFontOfSize:16];
    xcDesc.text = self.weather._64index_xc;
    [xcImageView addSubview:xcDesc];
    
    UILabel *xcDetail = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 300, 45)];
    xcDetail.backgroundColor = [UIColor clearColor];
    xcDetail.lineBreakMode = UILineBreakModeWordWrap;
    xcDetail.numberOfLines = 0;
    xcDetail.textColor = [UIColor whiteColor];
    xcDetail.textAlignment = NSTextAlignmentLeft;
    xcDetail.font = [UIFont systemFontOfSize:14];
    xcDetail.text = [self getXcDetailMessage:self.weather._64index_xc];
    [self.scrollView addSubview:xcDetail];
    
    //晨练指数
    UIImageView *clImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 290, self.view.frame.size.width,46)];
    clImageView.image = [UIImage imageNamed:@"itemTitle.png"];
    [self.scrollView addSubview:clImageView];
    
    UIImageView *clIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 40,40)];
    clIcon.image = [UIImage imageNamed:@"yundongzhishu.png"];
    [clImageView addSubview:clIcon];
    
    UILabel *clTitle = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 80,15)];
    clTitle.backgroundColor = [UIColor clearColor];
    clTitle.textColor = [UIColor whiteColor];
    clTitle.textAlignment = NSTextAlignmentLeft;
    clTitle.font = [UIFont boldSystemFontOfSize:16];
    clTitle.text = @"晨练指数";
    [clImageView addSubview:clTitle];
    
    UILabel *clDesc = [[UILabel alloc] initWithFrame:CGRectMake(240, 15, 80,15)];
    clDesc.backgroundColor = [UIColor clearColor];
    clDesc.textColor = [UIColor whiteColor];
    clDesc.textAlignment = NSTextAlignmentLeft;
    clDesc.font = [UIFont boldSystemFontOfSize:16];
    clDesc.text = self.weather._67index_cl;
    [clImageView addSubview:clDesc];
    
    UILabel *clDetail = [[UILabel alloc] initWithFrame:CGRectMake(10, 338, 300, 30)];
    clDetail.backgroundColor = [UIColor clearColor];
    clDetail.lineBreakMode = UILineBreakModeWordWrap;
    clDetail.numberOfLines = 0;
    clDetail.textColor = [UIColor whiteColor];
    clDetail.textAlignment = NSTextAlignmentLeft;
    clDetail.font = [UIFont systemFontOfSize:14];
    clDetail.text = [self getClDetailMessage:self.weather._67index_cl];
    [self.scrollView addSubview:clDetail];
    
    //晾晒指数
    UIImageView *lsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 370, self.view.frame.size.width,46)];
    lsImageView.image = [UIImage imageNamed:@"itemTitle.png"];
    [self.scrollView addSubview:lsImageView];
    
    UIImageView *lsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 40,40)];
    lsIcon.image = [UIImage imageNamed:@"ls_weather_index.png"];
    [lsImageView addSubview:lsIcon];
    
    UILabel *lsTitle = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 80,15)];
    lsTitle.backgroundColor = [UIColor clearColor];
    lsTitle.textColor = [UIColor whiteColor];
    lsTitle.textAlignment = NSTextAlignmentLeft;
    lsTitle.font = [UIFont boldSystemFontOfSize:16];
    lsTitle.text = @"晾晒指数";
    [lsImageView addSubview:lsTitle];
    
    UILabel *lsDesc = [[UILabel alloc] initWithFrame:CGRectMake(240, 15, 80,15)];
    lsDesc.backgroundColor = [UIColor clearColor];
    lsDesc.textColor = [UIColor whiteColor];
    lsDesc.textAlignment = NSTextAlignmentLeft;
    lsDesc.font = [UIFont boldSystemFontOfSize:16];
    lsDesc.text = self.weather._68index_ls;
    [lsImageView addSubview:lsDesc];
    
    UILabel *lsDetail = [[UILabel alloc] initWithFrame:CGRectMake(10, 415, 300, 30)];
    lsDetail.backgroundColor = [UIColor clearColor];
    lsDetail.lineBreakMode = UILineBreakModeWordWrap;
    lsDetail.numberOfLines = 0;
    lsDetail.textColor = [UIColor whiteColor];
    lsDetail.textAlignment = NSTextAlignmentLeft;
    lsDetail.font = [UIFont systemFontOfSize:14];
    lsDetail.text = [self getlsDetailMessage:self.weather._68index_ls];
    [self.scrollView addSubview:lsDetail];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (NSString *)getUvDetailMessage:(NSString *) uvtext
{
    if ([uvtext rangeOfString:@"最弱"].location != NSNotFound) {
        return [NSString stringWithFormat:@"紫外线太弱了，可以自由的户外活动，无须防护。"];
    } else if ([uvtext rangeOfString:@"很弱"].location != NSNotFound) {
        return [NSString stringWithFormat:@"紫外线%@，可以适当的晒晒太阳，带上遮阳帽吧。", uvtext];
    } else if ([uvtext rangeOfString:@"较弱"].location != NSNotFound) {
        return [NSString stringWithFormat:@"紫外线%@，户外运动可以少量涂擦护肤品，戴上遮阳帽噢。", uvtext];
    } else if ([uvtext rangeOfString:@"弱"].location != NSNotFound) {
        return [NSString stringWithFormat:@"紫外线%@，户外运动可以少量涂擦护肤品，戴上遮阳帽噢。", uvtext];
    } else if ([uvtext rangeOfString:@"中等"].location != NSNotFound) {
        return [NSString stringWithFormat:@"紫外线%@，户外运动可以少量涂擦护肤品，戴上遮阳帽噢。", uvtext];
    }
    
    if ([uvtext rangeOfString:@"最强"].location != NSNotFound) {
        return [NSString stringWithFormat:@"紫外线太强了，户外运动的注意涂擦护肤品，戴上遮阳帽。"];
    } else if ([uvtext rangeOfString:@"很强"].location != NSNotFound) {
        return [NSString stringWithFormat:@"紫外线%@，户外运动的注意涂擦护肤品，戴上遮阳帽。", uvtext];
    } else if ([uvtext rangeOfString:@"较强"].location != NSNotFound) {
        return [NSString stringWithFormat:@"紫外线%@，出门注意涂擦防晒霜噢，不要长时间户外运动。", uvtext];
    }else if ([uvtext rangeOfString:@"强"].location != NSNotFound) {
        return [NSString stringWithFormat:@"紫外线%@，出门注意涂擦防晒霜噢，不要长时间户外运动。", uvtext];
    }
    
    return @"";
}

- (NSString *)getXcDetailMessage:(NSString *) xctext
{
    if ([xctext rangeOfString:@"不适宜"].location != NSNotFound) {
        return [NSString stringWithFormat:@"建议大家别洗车了，天气不好，洗了之后可能很快会变脏的噢。"];
    } else if ([xctext rangeOfString:@"适宜"].location != NSNotFound) {
        return [NSString stringWithFormat:@"适合洗车的日子噢，开上您的爱车去旅行吧，享受生活吧。"];
    } else if ([xctext rangeOfString:@"不宜"].location != NSNotFound) {
        return [NSString stringWithFormat:@"建议大家别洗车了，天气不好，洗了之后可能很快会变脏的噢。"];
    }
    
    return @"";
}

- (NSString *)getClDetailMessage:(NSString *) cltext
{
    if ([cltext rangeOfString:@"不适宜"].location != NSNotFound) {
        return [NSString stringWithFormat:@"不太适宜，推荐您在室内进行晨练活动。"];
    } else if ([cltext rangeOfString:@"适宜"].location != NSNotFound) {
        return [NSString stringWithFormat:@"天气较好，去户外活动活动筋骨吧。"];
    } else if ([cltext rangeOfString:@"不宜"].location != NSNotFound) {
        return [NSString stringWithFormat:@"较不宜，推荐您在室内进行晨练活动。"];
    }
    
    return @"";
}

- (NSString *)getlsDetailMessage:(NSString *) lstext
{
    if ([lstext rangeOfString:@"不适宜"].location != NSNotFound) {
        return [NSString stringWithFormat:@"不适宜晾晒，天气不好。"];
    } else if ([lstext rangeOfString:@"不太适宜"].location != NSNotFound) {
        return [NSString stringWithFormat:@"较不宜，推荐您在室内晾衣服。"];
    } else if ([lstext rangeOfString:@"适宜"].location != NSNotFound) {
        return [NSString stringWithFormat:@"天气较好，适宜晾晒。"];
    } else if ([lstext rangeOfString:@"不宜"].location != NSNotFound) {
        return [NSString stringWithFormat:@"不适宜晾晒，天气不好。"];
    } 
    
    return @"";
}


@end
