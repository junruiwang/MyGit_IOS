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
        [self.localCityListManager buildLocalFileToArray:self.cityArray];
    }
    return self;
}

- (CityTableListViewController *)cityTableListViewController
{
    if (!_cityTableListViewController)
    {
        _cityTableListViewController = [[CityTableListViewController alloc] init];
    }
    return _cityTableListViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"城市管理";
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]
										   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCityBtnClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finishCitys:)];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.localCityListManager buildLocalFileToArray:self.cityArray];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//添加城市
- (void)addCityBtnClicked:(id)sender
{
    [self.navigationController pushViewController:self.cityTableListViewController animated:YES];
}

- (void)finishCitys:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
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
    CityTableViewCell *cell = cell = [[CityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CityTableViewCellIdentifier];
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
            cell.textLabel.text = @"当前所在城市";
            UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 8, 60, 20)];
            cityLabel.textColor = [UIColor blueColor];
            cityLabel.font = [UIFont boldSystemFontOfSize:18];
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
            cell.textLabel.text = city.cityName;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            return cell;
        }
    }
    
    return cell;
}

//打开编辑模式后，默认情况下每行左边会出现红的删除按钮，这个方法就是关闭这些按钮的
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

//group状态下怎么修改左边delete icon的位置
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//修改右边删除文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSUInteger row = [indexPath row];
        City *city = [self.cityArray objectAtIndex:row];
        [self.cityArray removeObjectAtIndex:row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.localCityListManager deleteCityInFaverate:city.cityName];
        [self.tableView reloadData];
    }
}

//开启行移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

//这个方法就是执行移动操作的
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSUInteger fromRow = [sourceIndexPath row];
    NSUInteger toRow = [destinationIndexPath row];
    
    City *city = [self.cityArray objectAtIndex:fromRow];
    [self.cityArray removeObjectAtIndex:fromRow];
    [self.cityArray insertObject:city atIndex:toRow];
    [self.tableView reloadData];
}

@end
