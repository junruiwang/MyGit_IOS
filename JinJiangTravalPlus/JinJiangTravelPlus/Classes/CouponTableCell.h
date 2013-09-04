//
//  CouponTableCell.h
//  JinJiangTravelPlus
//
//  Created by jerry on 13-1-5.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* couponName;
@property (nonatomic, weak) IBOutlet UILabel* amountLabel;
@property (nonatomic, weak) IBOutlet UILabel* periodLabel;
@property (nonatomic, weak) IBOutlet UILabel* scopeLabel;
@property (nonatomic, weak) IBOutlet UILabel* codeLabel;
@property (nonatomic, weak) IBOutlet UIImageView* statusImg;

@end
