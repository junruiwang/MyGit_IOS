//
//  SupportedBankListViewController.m
//  JinJiangTravelPlus
//
//  Created by huguiqi on 13-1-3.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "SupportedBankListViewController.h"
#import "SVProgressHUD.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface SupportedBankListViewController ()

@end

@implementation SupportedBankListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear frameSize:CGRectMake(55, 0, 295, screenRect.size.height + 20)];

    CGRect iphone4Frame = CGRectMake(0, 0, 320, 416);
    CGRect iphone5Frame = CGRectMake(0, 0, 320, 568);
    CGRect viewFrame = iPhone5? iphone5Frame : iphone4Frame;
    self.view.frame = viewFrame;
    self.view.backgroundColor = [UIColor clearColor];
    self.bankListTableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed.png"]];

    _debitCardList = _debitCardList == nil ? [[NSMutableArray alloc] init] : _debitCardList;
    _creditCardList = _creditCardList == nil ? [[NSMutableArray alloc] init] : _creditCardList;

    self.title = @"支持银行卡列表";
    self.bankListTableView.backgroundColor = [UIColor clearColor];
    self.bankListTableView.frame = viewFrame;

    [self.debitCardList removeAllObjects];
    [self.creditCardList removeAllObjects];
    [self.debitCardList addObjectsFromArray:[NSArray arrayWithObjects:@"工商银行", @"农业银行", @"建设银行", @"招商银行", @"交通银行(仅限广东)", @"光大银行", @"邮政储蓄银行", @"华夏银行", @"兴业银行", @"深圳发展银行", @"中信银行", @"平安银行", nil]];
    [self.creditCardList addObjectsFromArray:[NSArray arrayWithObjects:@"中国工商银行", @"中国农业银行", @"中国银行", @"中国建设银行", @"中国邮政储蓄银行", @"交通银行", @"光大银行", @"平安银行", @"中信银行", @"民生银行", @"兴业银行", @"华夏银行", @"浦东发展银行", @"广发银行", @"招商银行", @"上海银行", @"北京银行", nil]];
    [self.bankListTableView reloadData];
    [SVProgressHUD dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)   {   return self.debitCardList.count;    }
    else                {   return self.creditCardList.count;   }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)   {   return @"借记卡";  }
    else                {   return @"信用卡";  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize: 14];
    }

    if (indexPath.section == 0)
    {   cell.textLabel.text = [self.debitCardList objectAtIndex:indexPath.row]; }
    else if (indexPath.section == 1)
    {   cell.textLabel.text = [self.creditCardList objectAtIndex:indexPath.row];    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
