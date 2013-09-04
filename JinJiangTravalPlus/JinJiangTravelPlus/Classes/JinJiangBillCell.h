//
//  JinJiangBillCell.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-26.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JinJiangBillCellHeight 84
#define JinJiangBillCellWidth 304
#define CellHight 76
#define StatusImgSize 53
#define JinJiangBillCellIdentifier @"JinJiangBillCellReUseIdentifier_JinJiangTravelPlus"

@interface JinJiangBillCell : UITableViewCell

@property(nonatomic, strong)UIImageView* statusImg;
@property(nonatomic, strong)UILabel* hotelNameLabel;
@property(nonatomic, strong)UILabel* hotelPriceLabel;
@property(nonatomic, strong)UILabel* contactLabel;
@property(nonatomic, strong)UILabel* inDateLabel;
@property(nonatomic, strong)UILabel* outDateLabel;

@end
