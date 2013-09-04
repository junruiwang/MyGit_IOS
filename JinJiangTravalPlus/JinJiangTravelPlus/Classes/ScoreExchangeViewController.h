//
//  ScoreExchangeViewController.h
//  JinJiangTravelPlus
//
//  Created by jerry on 13-7-16.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "JJViewController.h"
#import "ScoreExchange.h"

@interface ScoreExchangeViewController : JJViewController

@property(nonatomic, strong) ScoreExchange *scoreExchange;

@property(nonatomic, weak) IBOutlet UIView *successView;
@property(nonatomic, weak) IBOutlet UIView *failView;

@property(nonatomic, weak) IBOutlet UILabel *couponMessage;
@property(nonatomic, weak) IBOutlet UILabel *totalCostScore;
@property(nonatomic, weak) IBOutlet UILabel *surplusScore;

@end
