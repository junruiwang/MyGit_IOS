//
//  IntegralRuleDetailViewController.h
//  JinJiangTravelPlus
//
//  Created by jerry on 13-7-15.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "JJViewController.h"
#import "IntegralRule.h"
#import "ScoreExchangeParser.h"

@interface IntegralRuleDetailViewController : JJViewController

@property(nonatomic, strong) IntegralRule *integralRule;
@property(nonatomic, assign) NSInteger totalCost;

@property(nonatomic, weak) IBOutlet UIImageView *couponImageView;
@property(nonatomic, weak) IBOutlet UILabel *ruleNameLabel;
@property(nonatomic, weak) IBOutlet UILabel *costLabel;
@property(nonatomic, weak) IBOutlet UILabel *useCostLabel;
@property(nonatomic, weak) IBOutlet UILabel *couponCount;
@property(nonatomic, weak) IBOutlet UITextView *itemTextView;
@property(nonatomic, weak) IBOutlet UIImageView *dashedTopImageView;
@property(nonatomic, weak) IBOutlet UIImageView *dashedBottomImageView;

@property(nonatomic, strong) ScoreExchangeParser *scoreExchangeParser;

- (IBAction)subButtonClicked:(id)sender;
- (IBAction)addButtonClicked:(id)sender;
- (IBAction)exchangeButtonClicked:(id)sender;

@end
