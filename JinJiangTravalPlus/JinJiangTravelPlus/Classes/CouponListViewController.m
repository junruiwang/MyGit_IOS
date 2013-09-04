//
//  CouponListViewController.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-22.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "CouponListViewController.h"
#import "JJCoupon.h"
#import "CouponTableCell.h"

@interface CouponListViewController ()

@end

@implementation CouponListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"会员中心优惠券页面";
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)varTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JJCoupon *coupon = (JJCoupon *) [self.couponArray objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"CouponTableCell";
    CouponTableCell *cell = [varTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.couponName.text = coupon.name;
    cell.amountLabel.text = [NSString stringWithFormat:@"￥%d", coupon.amount];
    cell.periodLabel.text = [NSString stringWithFormat:@"有效期：%@ 到 %@", coupon.startDate, coupon.endDate];
    cell.scopeLabel.text = [NSString stringWithFormat:@"适用范围：%@", coupon.usePlate];
    cell.codeLabel.text = coupon.code;

    switch (coupon.status)
    {
        case UNUSED:
        {   [cell.statusImg setImage:[UIImage imageNamed:@"coupon-unuse.png"]];  break;  }
        case USED:
        {   [cell.statusImg setImage:[UIImage imageNamed:@"coupon-used.png"]];  break;  }
        case OBSOLETE:
        {   [cell.statusImg setImage:[UIImage imageNamed:@"coupon-zuofei.png"]];  break; }
        case EXPIRED:
        {   [cell.statusImg setImage:[UIImage imageNamed:@"coupon-guoqi.png"]];  break;  }
        case LOCKED:
        {   [cell.statusImg setImage:[UIImage imageNamed:@"coupon-locked.png"]];  break;  }
        default:
        {   break;  }
    }
    
    return cell;
}

@end
