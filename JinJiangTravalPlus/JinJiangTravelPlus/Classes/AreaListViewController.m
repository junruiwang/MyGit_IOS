//
//  AreaListViewController.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 11/20/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "AreaListViewController.h"
#import "SVProgressHUD.h"
#import "AreaInfo.h"

@interface AreaListViewController ()

@end

@implementation AreaListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.areaListTableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)downloadData
{
    self.areaListHandle = [[AreaListHandle alloc] init];
    self.areaListHandle.areaListHandleDelegate = self;
    [self performSelector:@selector(showSVProgressHUD) withObject:nil afterDelay:0.2];
}

- (void)showSVProgressHUD
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear
                        frameSize:CGRectMake(25, 0, 295, screenRect.size.height + 20)];
    [self.areaListHandle buildAreas];
}

- (void)setAreaList:(NSMutableArray *)areaList
{
    if(areaList && [areaList count] && ![((AreaInfo *)areaList [0]).name isEqualToString:@"全部区域"])
    {
        AreaInfo *area = [[AreaInfo alloc] initWithName:@"全部区域"];
        [areaList insertObject:area atIndex:0];
    }
    self.areas = areaList;
    [self.areaListTableView reloadData];
    [SVProgressHUD dismiss];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.areas count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    const unsigned int row = [indexPath row];
    AreaInfo *areaInfo = [self.areas objectAtIndex:row];
    cell.textLabel.text = areaInfo.name;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    const unsigned int row = [indexPath row];
    AreaInfo *areaInfo = [self.areas objectAtIndex:row];
    [self.areaListDelegate selectArea:areaInfo.name];
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

@end
