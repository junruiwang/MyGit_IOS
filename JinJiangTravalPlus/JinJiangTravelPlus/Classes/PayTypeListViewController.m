//
//  PayTypeListViewController.m
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 12-12-13.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "PayTypeListViewController.h"
#import "PayType.h"

@interface PayTypeListViewController ()

@property(nonatomic, strong) UIControl *leftView;

@end

@implementation PayTypeListViewController

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.payTypeListTable.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.payTypeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CheckMarkCellIdentifier = @"PayTypeListCellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CheckMarkCellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CheckMarkCellIdentifier];
    }
    const unsigned int row = [indexPath row];
    PayType  *payType = [self.payTypeList objectAtIndex:row];

    if ([payType.name isEqualToString:@"GUARANTEE"] || [payType.name isEqualToString:@"PREPAYMENT"])
    {   cell.textLabel.text = [NSString stringWithFormat:@"%@ (需在线支付)", payType.label]; }
    else
    {   cell.textLabel.text = payType.label;    }

    cell.textLabel.font = [UIFont systemFontOfSize:16];

    cell.detailTextLabel.text = payType.description;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
    return cell;
}

#pragma mark -  UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    const unsigned int row = indexPath.row;

    PayType *payType = [self.payTypeList objectAtIndex:row];

    if (payType != nil)
    {
       [self.delegate selectedPayType:payType];
    }

    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
