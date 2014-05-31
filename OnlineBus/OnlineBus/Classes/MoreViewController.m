//
//  MoreViewController.m
//  OnlineBus
//
//  Created by jerry on 13-12-7.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//

#import "MoreViewController.h"
#import "Constants.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"更多信息页面";
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.parentViewController.navigationItem.title = @"更多";
}

- (void)viewDidUnload
{
    self.tableView = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"软件信息";
    }
    if (section == 1) {
        return @"关于";
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }
    if (section == 1) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MoreTableCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"在线公交查询2.3版";
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    return cell;
                }
                case 1:
                {
                    cell.textLabel.text = @"支持城市：苏州";
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    return cell;
                }
                case 2:
                {
                    cell.textLabel.text = @"给我们评分吧";
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 15, 6, 9)];
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
        case 1:
        {
            cell.textLabel.text = @"关于软件";
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 15, 6, 9)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        [cell setSelected:NO animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreUrl]];
    }
    
    if (indexPath.section == 1) {
        [cell setSelected:NO animated:YES];
        [self performSegueWithIdentifier:FROM_MORE_TO_ABOUTUS sender:nil];
    }
}

@end
