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
#import "WeatherWeekDayParser.h"
#import "SqliteService.h"
#import "ServerAddressManager.h"

@interface CityTableListViewController ()

@property (nonatomic, strong) LocalCityListManager *localCityListManager;
@property(nonatomic, strong) WeatherWeekDayParser *weatherWeekDayParser;

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
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	self.searchBar.tintColor = [UIColor blackColor];
    self.searchBar.placeholder = @"查找";
    
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeDefault;
	self.tableView.tableHeaderView = self.searchBar;
	
	// Create the search display controller
	self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
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
        City *city = [self.FilterArray objectAtIndex:indexPath.row];
        [self.localCityListManager insertIntoFaverateWithCity:city];
        
        [NSThread detachNewThreadSelector:@selector(startTheBackgroundJob:) toTarget:self withObject:city.searchCode];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
}

//后台下载城市天气
- (void)startTheBackgroundJob:(NSString *)searchCode
{
    if (self.weatherWeekDayParser!= nil) {
        [self.weatherWeekDayParser cancel];
        self.weatherWeekDayParser = nil;
    }
    self.weatherWeekDayParser = [[WeatherWeekDayParser alloc] init];
    
    ModelWeather *weather = [[ModelWeather alloc] init];
    NSString *resourceAddress = [ServerAddressManager serverAddress:@"query_weather_current_time"];
    self.weatherWeekDayParser.serverAddress = [resourceAddress stringByAppendingFormat:@"%@.html", searchCode];
    [self.weatherWeekDayParser startSynchronous:weather];
    resourceAddress = [ServerAddressManager serverAddress:@"query_weather_week_day"];
    self.weatherWeekDayParser.serverAddress = [resourceAddress stringByAppendingFormat:@"%@.html", searchCode];
    [self.weatherWeekDayParser startSynchronous:weather];
    
    SqliteService *sqlservice=[[SqliteService alloc]init];
    [sqlservice insertModel:weather];
}

@end
