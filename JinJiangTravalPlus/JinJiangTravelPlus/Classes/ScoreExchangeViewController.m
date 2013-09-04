//
//  ScoreExchangeViewController.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-7-16.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "ScoreExchangeViewController.h"

@interface ScoreExchangeViewController ()

@end

@implementation ScoreExchangeViewController

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
    self.title = @"积分兑换";
    [self loadPageViewByAll];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPageViewByAll
{
    if (self.scoreExchange.successFlag) {
        self.successView.hidden = NO;
        self.failView.hidden = YES;
        
        NSString *validPoint = TheAppDelegate.userInfo.point;
        
        self.couponMessage.text = [NSString stringWithFormat:@"%d元优惠券%d张", self.scoreExchange.faceValue, self.scoreExchange.couponCount];
        self.totalCostScore.text = [NSString stringWithFormat:@"%d积分", self.scoreExchange.totalCost];
        self.surplusScore.text = [NSString stringWithFormat:@"%d积分", ([validPoint intValue] - self.scoreExchange.totalCost)];
        
    } else {
        self.successView.hidden = YES;
        self.failView.hidden = NO;
    }
}

@end
