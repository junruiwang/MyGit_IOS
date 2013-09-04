//
//  PromotionCell.h
//  JinJiangHotel
//
//  Created by Rong Hao on 13-9-2.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Promotion.h"

@class PromotionCell;
@protocol PromotionCellDelegate <NSObject>

- (void)shareButtonClick:(PromotionCell *)sender;

@end

@interface PromotionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *promitionImageView;
@property (weak, nonatomic) IBOutlet UILabel *promotionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promotionDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *seperateLine;
@property (nonatomic, weak) id<PromotionCellDelegate> delegate;
@property (nonatomic, strong) Promotion *promotion;

@end

