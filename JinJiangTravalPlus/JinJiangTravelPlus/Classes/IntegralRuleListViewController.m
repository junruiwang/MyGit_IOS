//
//  IntegralRuleListViewController.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-7-10.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "IntegralRuleListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IntegralRuleDetailViewController.h"

@interface IntegralRuleListViewController ()

@property(nonatomic, strong) IntegralRule *integralRule;
@property (nonatomic, strong) UILabel* tipLabel;
@property (nonatomic, strong) UIImageView *dashView;
@end

@implementation IntegralRuleListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _integralRuleArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"积分兑换";
    self.trackedViewName = @"积分兑换优惠券产品列表页面";
    [self initBackGroundView];
    [self downloadData];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadData
{
    [self showIndicatorView];
    if (!self.integralRuleListParser)
    {
        self.integralRuleListParser = [[IntegralRuleListParser alloc] init];
        self.integralRuleListParser.serverAddress = kIntegralRuleListURL;
    }
    [self.integralRuleListParser setDelegate:self];
    [self.integralRuleListParser start];
}

- (void)initBackGroundView
{
    CALayer *subLayer = [CALayer layer];
    subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    subLayer.cornerRadius = 5;
    subLayer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    subLayer.borderWidth = 1;
    
    subLayer.frame = CGRectMake(0, 1, self.bgView.frame.size.width, self.bgView.frame.size.height-45);
    [self.bgView.layer addSublayer:subLayer];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.integralRuleArray count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IntegralRuleTableCell *cell = (IntegralRuleTableCell *)[tableView dequeueReusableCellWithIdentifier:@"IntegralRuleTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dashedImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
    IntegralRule *integralRule = self.integralRuleArray[indexPath.row];
    
    switch (integralRule.couponTypeVal) {
        case JJCouponTen:
            cell.couponImageView.image = [UIImage imageNamed:@"coupon_10.png"];
            break;
        case JJCouponFifty:
            cell.couponImageView.image = [UIImage imageNamed:@"coupon_50.png"];
            break;
        case JJCouponHundred:
            cell.couponImageView.image = [UIImage imageNamed:@"coupon_100.png"];
            break;
        default:
            break;
    }
    cell.ruleNameLabel.text = integralRule.ruleName;
    cell.costLabel.text = [NSString stringWithFormat:@"%d分",integralRule.cost];
    cell.integralRule = integralRule;
    cell.delegate = self;
    return cell;
}

#pragma mark - GDataXMLParserDelegate

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    self.integralRuleArray = data[@"integralRuleList"];
    [self afterParserCoupons];
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    [self hideIndicatorView];
}

#pragma mark - IntegralRuleCellDelegate

- (void)afterExchangeButtonClicked:(IntegralRule *) integralRule
{
    self.integralRule = integralRule;
    [self performSegueWithIdentifier:@"IntegralRuleDetail" sender:nil];
}

//冒泡排序
- (void)sortByIntegralRuleArray
{
    int arraylength = self.integralRuleArray.count;
    
    if (arraylength > 0) {
        for (int i=0; i < (arraylength - 1); i++) {
            for (int m=0; m < (arraylength-i-1); m++) {
                IntegralRule *currentRule = self.integralRuleArray[m];
                IntegralRule *nextRule = self.integralRuleArray[m+1];
                if (currentRule.couponTypeVal > nextRule.couponTypeVal) {
                    [self.integralRuleArray replaceObjectAtIndex:m withObject:nextRule];
                    [self.integralRuleArray replaceObjectAtIndex:(m+1) withObject:currentRule];
                }
            }
        }
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"IntegralRuleDetail"])
    {
        IntegralRuleDetailViewController *ruleDetailViewController = (IntegralRuleDetailViewController *)(segue.destinationViewController);
        ruleDetailViewController.integralRule = self.integralRule;
    }
}

- (void)afterParserCoupons
{
    if (self.integralRuleArray.count > 0) {
        [self sortByIntegralRuleArray];
        [self.tableView reloadData];
    } else {
        self.tableView.hidden = YES;
        self.tipLabel= [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 170, 21)];
        self.tipLabel.backgroundColor = [UIColor clearColor];
        self.tipLabel.textColor = RGBCOLOR(60, 60, 60);
        self.tipLabel.font = [UIFont systemFontOfSize:15];
        self.tipLabel.text = @"暂无可以积分兑换的产品";
        self.dashView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 53, 280, 1)];
        self.dashView.image = [UIImage imageNamed:@"hotel-dashes.png"];
        
        [self.bgView addSubview:self.tipLabel];
        [self.bgView addSubview:self.dashView];
    }
    [self hideIndicatorView];
}

@end
