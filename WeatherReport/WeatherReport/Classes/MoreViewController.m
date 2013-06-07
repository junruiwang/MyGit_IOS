//
//  BannerViewController.h
//  WeatherReport
//
//  Created by jerry on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "MoreViewController.h"
#import "PrettyTableViewCell.h"
#import "AppDelegate.h"
#import "ShareToSNSManager.h"
#import "AboutViewController.h"

@interface MoreViewController ()

@property(nonatomic, strong) ShareToSNSManager *shareToSNSManager;

@end

@implementation MoreViewController

- (id)init
{
    self = [super init];
    if (self) {
        _shareToSNSManager = [[ShareToSNSManager alloc] init];
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
    self.navigationItem.title = @"更多";
    float imageHeight = 367;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        imageHeight += 88;
    }
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imageHeight)];
    bgImageView.backgroundColor = [UIColor clearColor];
    bgImageView.image = [UIImage imageNamed:@"load_bg5.png"];
    [self.view addSubview:bgImageView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imageHeight) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"位置信息";
    }
    if (section == 1) {
        return @"软件信息";
    }
    if (section == 2) {
        return @"关于";
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 3;
    }
    if (section == 2) {
        return 1;
    }
    
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
    }
    //下降阴影
    cell.dropsShadow = NO;
    //圆弧
    cell.cornerRadius = 10;
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
            cityLabel.text = TheAppDelegate.locationInfo.cityName;
            cityLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:cityLabel];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [cell prepareForTableView:tableView indexPath:indexPath];
                    cell.textLabel.text = @"酷旅天气系统1.0版";
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    return cell;
                }
                case 1:
                {
                    [cell prepareForTableView:tableView indexPath:indexPath];
                    cell.textLabel.text = @"给我们评分吧";
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 15, 7, 10)];
                    imageView.image = [UIImage imageNamed:@"line-next.png"];
                    [cell.contentView addSubview:imageView];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                    return cell;
                }
                case 2:
                {
                    [cell prepareForTableView:tableView indexPath:indexPath];
                    cell.textLabel.text = @"分享我们";
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 15, 7, 10)];
                    imageView.image = [UIImage imageNamed:@"line-next.png"];
                    [cell.contentView addSubview:imageView];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                    return cell;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            [cell prepareForTableView:tableView indexPath:indexPath];
            cell.textLabel.text = @"关于酷旅";
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 15, 7, 10)];
            imageView.image = [UIImage imageNamed:@"line-next.png"];
            [cell.contentView addSubview:imageView];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            return cell;
        }
        default:
            break;
    }
    
    return cell;
}


#pragma mark - Table view delegate

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        PrettyTableViewCell *cell = (PrettyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO animated:YES];
        
        switch (indexPath.row) {
            case 1:
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kCommentUrl]];
                break;
            }
            case 2:
            {
                [self shareBtnClicked:nil];
                break;
            }
            default:
                break;
        }
    }
    
    if (indexPath.section == 2) {
        PrettyTableViewCell *cell = (PrettyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO animated:YES];
        AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        [self.navigationController pushViewController:aboutViewController animated:YES];
    }
}

- (void)shareBtnClicked:(id)sender
{
    [self.shareToSNSManager shareWithActionSheet:self shareImage:[UIImage imageNamed:@"icon.png"] shareText:[self buildCurrentCityWeatherString]];
}

- (NSString *)buildCurrentCityWeatherString
{
    ModelWeather *tempWeather = TheAppDelegate.modelWeather;
    NSString *weatherString = [NSString stringWithFormat:@"%@ %@ %@ %@%@。（来自酷旅天气 免费下载%@）", tempWeather._1city,tempWeather._16weather1,tempWeather._10temp1,tempWeather._5WD,tempWeather._6WS,kAppStoreUrl];
    
    return weatherString;
}

@end
