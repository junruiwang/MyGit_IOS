//
//  IntegralRuleTableCell.h
//  JinJiangTravelPlus
//
//  Created by jerry on 13-7-11.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntegralRule.h"

#pragma mark - IntegralRuleCellDelegate

@protocol IntegralRuleCellDelegate <NSObject>

@required

- (void)afterExchangeButtonClicked:(IntegralRule *) integralRule;

@end

#pragma mark - IntegralRuleTableCell

@interface IntegralRuleTableCell : UITableViewCell
@property(nonatomic, strong) IntegralRule *integralRule;
@property(nonatomic, weak) IBOutlet UIImageView *couponImageView;
@property(nonatomic, weak) IBOutlet UILabel *ruleNameLabel;
@property(nonatomic, weak) IBOutlet UILabel *costLabel;
@property(nonatomic, weak) IBOutlet UIImageView *dashedImageView;
@property(nonatomic, weak)id<IntegralRuleCellDelegate> delegate;

- (IBAction)exchangeButtonTapped:(id)sender;

@end
