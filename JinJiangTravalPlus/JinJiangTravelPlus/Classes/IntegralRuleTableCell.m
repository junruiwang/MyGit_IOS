//
//  IntegralRuleTableCell.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-7-11.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "IntegralRuleTableCell.h"

@implementation IntegralRuleTableCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)exchangeButtonTapped:(id)sender
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(afterExchangeButtonClicked:)])
    {
        [self.delegate afterExchangeButtonClicked:self.integralRule];
    }
}

@end
