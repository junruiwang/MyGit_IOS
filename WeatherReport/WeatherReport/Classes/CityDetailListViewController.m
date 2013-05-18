//
//  CityDetailListViewController.m
//  WeatherReport
//
//  Created by 汪君瑞 on 13-5-18.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "CityDetailListViewController.h"
#import "ChineseToPinyin.h"
#import "LocalCityListManager.h"

@interface CityDetailListViewController ()

@property (nonatomic, strong) LocalCityListManager *localCityListManager;

@end

@implementation CityDetailListViewController

- (id)init
{
    self = [super init];
    if (self) {
        _cityArray=[[NSMutableArray alloc] initWithCapacity:10];
        _fileArray=[[NSMutableDictionary alloc] init];
        _FilterArray=[[NSMutableArray alloc] initWithCapacity:10];
        _localCityListManager = [[LocalCityListManager alloc] init];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self.cityArray removeAllObjects];
    [self.fileArray removeAllObjects];
    
    NSString *pathCode = [[NSBundle mainBundle] pathForResource:@"cityList" ofType:@"plist"];
    NSDictionary *dictCode = [NSDictionary dictionaryWithContentsOfFile:pathCode];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"provinceCity" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *cityAry = [dict valueForKey:self.currentProvince];
    for (int m=0; m < [cityAry count]; m++) {
        NSString *cityString=[NSString stringWithFormat:@"%@ %@", cityAry[m], [ChineseToPinyin pinyinFromChiniseString:cityAry[m]]];
        City *city = [[City alloc] init];
        city.province = self.currentProvince;
        city.cityName = cityAry[m];
        city.searchCode = [dictCode valueForKey:cityAry[m]];
        [self.cityArray addObject:city];
        [self.fileArray setObject:cityString forKey:cityString];
    }
    
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
    self.navigationItem.title = self.currentProvince;
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
        return self.cityArray.count;
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
            city.province = self.currentProvince;
            city.cityName = cityName;
            city.searchCode = [dict valueForKey:cityName];
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
        City *city = [self.cityArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityName;
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        return cell;
    } else {
        City *city = [self.FilterArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityName;
        return  cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    City *city;
    if (tableView==self.tableView) {
        city = [self.cityArray objectAtIndex:indexPath.row];
    } else {
        city = [self.FilterArray objectAtIndex:indexPath.row];
    }
    
    [self.localCityListManager insertIntoFaverateWithCity:city];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
