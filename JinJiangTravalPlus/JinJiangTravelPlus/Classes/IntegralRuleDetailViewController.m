//
//  IntegralRuleDetailViewController.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-7-15.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "IntegralRuleDetailViewController.h"
#import "ParameterManager.h"
#import "ScoreExchange.h"
#import "ScoreExchangeViewController.h"

@interface IntegralRuleDetailViewController ()

@property(nonatomic, strong) ScoreExchange *scoreExchange;

@end

@implementation IntegralRuleDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _scoreExchange = [[ScoreExchange alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"积分兑换";
    [self loadBaseContentPage];
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
    if (!self.scoreExchangeParser)
    {
        self.scoreExchangeParser = [[ScoreExchangeParser alloc] init];
        self.scoreExchangeParser.serverAddress = kScoreExchangeURL;
    }
    ParameterManager *parameterManager = [[ParameterManager alloc] init];
    [parameterManager parserStringWithKey:@"productId" WithValue:self.integralRule.mobileScoreGoodsId];
    [parameterManager parserStringWithKey:@"issueCount" WithValue:self.couponCount.text];
    
    self.scoreExchangeParser.requestString = [parameterManager serialization];
    [self.scoreExchangeParser setDelegate:self];
    [self.scoreExchangeParser start];
}

- (void)loadBaseContentPage
{
    self.dashedTopImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
    self.dashedBottomImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
    self.itemTextView.text = [NSString stringWithFormat:@"积分兑换优惠券使用说明：\n 1：优惠券有效期至：%@\n 2：优惠券可在锦江旅行家APP中用于购买锦江之星和星级酒店\n 3：使用优惠券的订单必须在线支付\n 4：一张订单可使用多张优惠券（超出订单金额部分不做退还）\n 5：使用优惠券部分的订单金额酒店不提供发票\n 6：最终解释权归上海锦江国际电子商务有限公司",self.integralRule.invalidDate];
    
    switch (self.integralRule.couponTypeVal) {
        case JJCouponTen:
            self.couponImageView.image = [UIImage imageNamed:@"coupon_10.png"];
            break;
        case JJCouponFifty:
            self.couponImageView.image = [UIImage imageNamed:@"coupon_50.png"];
            break;
        case JJCouponHundred:
            self.couponImageView.image = [UIImage imageNamed:@"coupon_100.png"];
            break;
        default:
            break;
    }
    
    self.ruleNameLabel.text = self.integralRule.ruleName;
    self.costLabel.text = [NSString stringWithFormat:@"%d分",self.integralRule.cost];
    self.useCostLabel.text = [NSString stringWithFormat:@"%d分",self.integralRule.cost];
    self.couponCount.text = @"1";
    self.totalCost = self.integralRule.cost;
}


- (IBAction)subButtonClicked:(id)sender
{
    int couponNum = [self.couponCount.text intValue];
    if (couponNum > 1) {
        couponNum -= 1;
        self.couponCount.text = [NSString stringWithFormat:@"%d", couponNum];
        self.totalCost = self.integralRule.cost*couponNum;
        self.useCostLabel.text = [NSString stringWithFormat:@"%d分",self.totalCost];
    }
}

- (IBAction)addButtonClicked:(id)sender
{
    int couponNum = [self.couponCount.text intValue];
    if (couponNum < 99) {
        couponNum += 1;
        self.couponCount.text = [NSString stringWithFormat:@"%d", couponNum];
        self.totalCost = self.integralRule.cost*couponNum;
        self.useCostLabel.text = [NSString stringWithFormat:@"%d分",self.totalCost];
    }
}

- (IBAction)exchangeButtonClicked:(id)sender
{
    NSString *validPoint = TheAppDelegate.userInfo.point;
    
    if(TheAppDelegate.userInfo.isTempMember && [TheAppDelegate.userInfo.isTempMember caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        [self showAlertMessage:@"网站会员无法兑换优惠券！"];
        return;
    }
    
    if(validPoint == nil) {
        [self showAlertMessage:@"无可用积分！"];
        return;
    }
    
    if (self.totalCost > validPoint.intValue) {
        [self showAlertMessage:@"积分不足，无法兑换优惠券！"];
        return;
    }
    //调用积分兑换优惠券接口
    [self downloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"scoreExchange"])
    {
        ScoreExchangeViewController *scoreExchangeViewController = (ScoreExchangeViewController *)(segue.destinationViewController);
        scoreExchangeViewController.scoreExchange = self.scoreExchange;
    }
}

#pragma mark - GDataXMLParserDelegate

- (void)parser:(GDataXMLParser *)parser DidParsedData:(NSDictionary *)data
{
    [self hideIndicatorView];
    self.scoreExchange.successFlag = YES;
    self.scoreExchange.faceValue = self.integralRule.couponTypeVal;
    self.scoreExchange.couponCount = [self.couponCount.text intValue];
    self.scoreExchange.totalCost = self.totalCost;
    [self performSegueWithIdentifier:@"scoreExchange" sender:nil];
}

- (void)parser:(GDataXMLParser *)parser DidFailedParseWithMsg:(NSString *)msg errCode:(NSInteger)code
{
    [self hideIndicatorView];
    self.scoreExchange.successFlag = NO;
    [self performSegueWithIdentifier:@"scoreExchange" sender:nil];
}

@end
