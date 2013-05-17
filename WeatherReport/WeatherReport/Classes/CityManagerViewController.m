//
//  CityManagerViewController.m
//  WeatherReport
//
//  Created by jerry on 13-5-17.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "CityManagerViewController.h"
#import "CityTableViewCell.h"
#import "City.h"


@interface CityManagerViewController ()

@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) LocalCityListManager *localCityListManager;
@property(nonatomic, strong) CityTableListViewController *cityTableListViewController;

@end

@implementation CityManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _localCityListManager = [[LocalCityListManager alloc] init];
        _cityArray = [[NSMutableArray alloc] initWithCapacity:10];
        [self mockLocalCity];
        [self.localCityListManager buildLocalFileToArray:self.cityArray];
    }
    return self;
}

- (void)mockLocalCity
{
    City *city_1 = [[City alloc] init];
    city_1.province = @"湖北";
    city_1.cityName = @"武汉";
    city_1.searchCode = @"5264512545";
    [self.localCityListManager insertIntoFaverateWithCity:city_1];
    
    City *city_2 = [[City alloc] init];
    city_2.province = @"湖北";
    city_2.cityName = @"黄石";
    city_2.searchCode = @"5264512545";
    [self.localCityListManager insertIntoFaverateWithCity:city_2];
    
    City *city_3 = [[City alloc] init];
    city_3.province = @"湖北";
    city_3.cityName = @"襄阳";
    city_3.searchCode = @"5264512545";
    [self.localCityListManager insertIntoFaverateWithCity:city_3];
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
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]
										   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCityBtnClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleEdit:)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleEdit:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing)
        [self.navigationItem.rightBarButtonItem setTitle:@"完成"];
    else
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
}

//添加城市
- (void)addCityBtnClicked:(id)sender
{
    [self.navigationController pushViewController:self.cityTableListViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    if (section == 1) {
        return [self.cityArray count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CityTableViewCellIdentifier = @"CityTableViewCell";
    CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CityTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[CityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CityTableViewCellIdentifier];
    }
    //cell背景色
    cell.backgroundColor = [UIColor whiteColor];
    //下降阴影
    cell.dropsShadow = NO;
    //圆弧
    cell.cornerRadius = 5;
    //选中行背景色
    cell.selectionGradientStartColor = RGBCOLOR(231, 231, 231);
    cell.selectionGradientEndColor = RGBCOLOR(231, 231, 231);
    
    switch (indexPath.section) {
        case 0:
        {
            [cell prepareForTableView:tableView indexPath:indexPath];
            cell.textLabel.text = @"当前城市";
            UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, 60, 20)];
            cityLabel.textColor = [UIColor blueColor];
            cityLabel.font = [UIFont systemFontOfSize:18];
            cityLabel.text = @"上海";
            cityLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:cityLabel];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        case 1:
        {
            //下降阴影
            cell.dropsShadow = NO;
            //圆弧
            cell.cornerRadius = 5;
            //cell之间的分割线
            cell.customSeparatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
            
            [cell prepareForTableView:tableView indexPath:indexPath];
            
            City *city = [self.cityArray objectAtIndex:[indexPath row]];
            cell.textLabel.text = [NSString stringWithFormat:@"%@.%@", city.province, city.cityName];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            return cell;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSUInteger row = [indexPath row];
        City *city = [self.cityArray objectAtIndex:row];
        [self.cityArray removeObjectAtIndex:row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.localCityListManager deleteCityInFaverate:city.cityName];
    }
}

#pragma mark - CityTableListViewDelegate
- (void)citySelected:(NSString *)cityName;
{
    NSLog(@"城市：%@", cityName);
}

@end
