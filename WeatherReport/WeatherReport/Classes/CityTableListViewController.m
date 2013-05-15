    //
//  CityTableListViewController.m
//  WeatherInfo
//
//  Created by Wu Jing on 11-5-12.
//  Copyright 2011 cfmetinfo. All rights reserved.
//

#import "CityTableListViewController.h"
#import "ChineseToPinyin.h"

@implementation CityTableListViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.cityNames= [[NSMutableArray alloc] init];
        [self.cityNames addObject:@"上海"];
        [self.cityNames addObject:@"南京"];
        [self.cityNames addObject:@"无锡"];
        [self.cityNames addObject:@"徐州"];
        [self.cityNames addObject:@"常州"];
        [self.cityNames addObject:@"苏州"];
        [self.cityNames addObject:@"南通"];
        [self.cityNames addObject:@"连云港"];
        [self.cityNames addObject:@"淮安"];
        [self.cityNames addObject:@"盐城"];
        [self.cityNames addObject:@"扬州"];
        [self.cityNames addObject:@"镇江"];
        [self.cityNames addObject:@"泰州"];
        [self.cityNames addObject:@"宿迁"];
        
        _allCitys=[[NSMutableArray alloc]init];
        _fileArray=[[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{ 
	
	return 1; 
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
	if(aTableView==self.tableView){
        return self.cityNames.count;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", self.searchBar.text];
        self.FilterArray=[self.fileArray.allKeys filteredArrayUsingPredicate:predicate];
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
        cell.textLabel.text = [self.cityNames objectAtIndex:indexPath.row];
        return cell;
    } else {
        cell.textLabel.text = [self.FilterArray objectAtIndex:indexPath.row];;
        return  cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (tableView==self.tableView) {
        NSString *cityName = [self.cityNames objectAtIndex:indexPath.row];
        [self.delegate citySelected:cityName];
    } else {
        NSString *cityName = [self.FilterArray objectAtIndex:indexPath.row];
        [self.delegate citySelected:[cityName substringToIndex:[cityName rangeOfString:@" "].location]];
    }
}

- (void)loadView {
    [super loadView];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	self.searchBar.tintColor = [UIColor blackColor];
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
	self.tableView.tableHeaderView = self.searchBar;
	
	// Create the search display controller
	self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
	self.searchDC.searchResultsDataSource = self;
	self.searchDC.searchResultsDelegate = self;
	
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"添加城市";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cityList" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.allCitys = [[dict allKeys] mutableCopy];
    //[self.allCitys addObjectsFromArray:[dict allKeys]];
    
    for (int i=0; i<[self.allCitys count]; i++) {
        NSString *cityName = [self.allCitys objectAtIndex:i];
        NSString *city=[NSString stringWithFormat:@"%@ %@", cityName, [ChineseToPinyin pinyinFromChiniseString:cityName]];
        [self.fileArray setObject:city forKey:city];
    }
    
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

@end
