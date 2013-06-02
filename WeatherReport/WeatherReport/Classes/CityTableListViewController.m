    //
//  CityTableListViewController.m
//  WeatherInfo
//
//  Created by Wu Jing on 11-5-12.
//  Copyright 2011 cfmetinfo. All rights reserved.
//

#import "CityTableListViewController.h"
#import "ChineseToPinyin.h"
#import "LocalCityListManager.h"
#import "CityDetailListViewController.h"
#import "SqliteService.h"
#import "ServerAddressManager.h"
#import "SVProgressHUD.h"

@interface CityTableListViewController ()

@property (nonatomic, strong) LocalCityListManager *localCityListManager;
@property(nonatomic, strong) WeatherDayParser *weatherDayParser;
@property(nonatomic, strong) WeatherAWeekParser *weatherAWeekParser;
@property(nonatomic, strong) ModelWeather *weather;
@property(nonatomic, strong) City *selectedCity;

@end

@implementation CityTableListViewController

- (id)init
{
    self = [super init];
    if (self) {
        _provinceArray=[[NSMutableArray alloc] init];
        _fileArray=[[NSMutableDictionary alloc] init];
        _FilterArray=[[NSMutableArray alloc] initWithCapacity:50];
        _localCityListManager = [[LocalCityListManager alloc] init];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"provinceCity" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        
        self.provinceArray = [[dict allKeys] mutableCopy];
        
        for (int i=0; i < [self.provinceArray count]; i++) {
            NSString *province = [self.provinceArray objectAtIndex:i];
            NSArray *cityAry = [dict valueForKey:province];
            for (int m=0; m < [cityAry count]; m++) {
                NSString *city=[NSString stringWithFormat:@"%@.%@ %@", province, cityAry[m], [ChineseToPinyin pinyinFromChiniseString:cityAry[m]]];
                [self.fileArray setObject:city forKey:city];
            }
        }
    }
    return self;
}

- (void)loadView {
    [super loadView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	self.searchBar.tintColor = [UIColor blackColor];
    self.searchBar.placeholder = @"查找";
    
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeDefault;
	self.tableView.tableHeaderView = self.searchBar;
	
	// Create the search display controller
	self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDC.delegate = self;
	self.searchDC.searchResultsDataSource = self;
	self.searchDC.searchResultsDelegate = self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"省份";
    self.tableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{ 
	
	return 1; 
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
	if(aTableView==self.tableView){
        return self.provinceArray.count;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", self.searchBar.text];
        NSArray *tempFilterArray = [self.fileArray.allKeys filteredArrayUsingPredicate:predicate];
        [self.FilterArray removeAllObjects];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cityList" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        
        for (int i=0; i < [tempFilterArray count]; i++) {
            NSString *cityName = [tempFilterArray objectAtIndex:i];
            cityName = [cityName substringToIndex:[cityName rangeOfString:@" "].location];
            City *city = [[City alloc] init];
            city.province = [cityName substringToIndex:[cityName rangeOfString:@"."].location];
            city.cityName = [cityName substringFromIndex:([cityName rangeOfString:@"."].location + 1)];
            city.searchCode = [dict valueForKey:city.cityName];
            [self.FilterArray addObject:city];
        }
        
        return [self.FilterArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellStyle style =  UITableViewCellStyleDefault;
	UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:@"BaseCell"];
	if (!cell) 
		cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:@"BaseCell"];
    
    if (tView==self.tableView) {
        cell.textLabel.text = [self.provinceArray objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        return cell;
    } else {
        City *city = [self.FilterArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@.%@", city.province, city.cityName];
        return  cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (tableView==self.tableView) {
        NSString *provinceName = [self.provinceArray objectAtIndex:indexPath.row];
        CityDetailListViewController *cityDetailListViewController = [[CityDetailListViewController alloc] init];
        cityDetailListViewController.currentProvince = provinceName;
        [self.navigationController pushViewController:cityDetailListViewController animated:YES];
    } else {
        [SVProgressHUD showWithStatus:@"正在获取所选城市天气" maskType:SVProgressHUDMaskTypeGradient];
        City *city = [self.FilterArray objectAtIndex:indexPath.row];
        [self performSelector:@selector(startTheBackgroundJob:) withObject:city afterDelay:0.5];
    }
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
}

#pragma mark - UISearchDisplayDelegate
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    UISearchBar *searchBar = self.searchDisplayController.searchBar;
    [searchBar setShowsCancelButton:YES animated:YES];
    
    for(UIView *subView in searchBar.subviews){
        if([subView isKindOfClass:UIButton.class]){
            [(UIButton*)subView setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void)downloadDataForDay:(NSString *)searchCode
{
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

//后台下载城市天气
- (void)startTheBackgroundJob:(City *)city
{
    //插入城市信息
    if ([self.localCityListManager insertIntoFaverateWithCity:city]) {
        self.selectedCity = city;
        [self downloadDataForDay:city.searchCode];
    } else {
        [SVProgressHUD dismiss];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - BaseParserDelegate
- (void)parser:(BaseParser*)parser DidFailedParseWithMsg:(NSString*)msg errCode:(NSInteger)code
{
    [SVProgressHUD dismiss];
    [self.localCityListManager deleteCityInFaverate:self.selectedCity.searchCode];
    
    NSLog(@"查询一周天气信息发生异常：%@，错误代码：%d", msg, code);
    
    [self showAlertMessage:@"网络连接异常，请重新选择城市！"];
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
        
        //插入天气信息
        SqliteService *sqlservice=[[SqliteService alloc]init];
        if (![sqlservice insertModel:self.weather]) {
            [self.localCityListManager deleteCityInFaverate:self.weather._2cityid];
        }
        
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showAlertMessage:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"信息提示", nil)
                              message:msg
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                              otherButtonTitles:nil];
    [alertView show];
}

@end
