//
//  JJEffectiveBillCell.h
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-5-20.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "JJHotel.h"

#define JinJiangEffectiveBillCellHeight 144.5
#define JinJiangBillCellWidth 304
#define CellHight 76
#define StatusImgSize 53
#define JinJiangBillCellIdentifier @"JinJiangBillCellReUseIdentifier_JinJiangTravelPlus"
#define JinJiangBillEffectiveCellIdentifier @"JinJiangBillEffectiveCellReUseIdentifier_JinJiangTravelPlus"

@class JJEffectiveBillCell;
@protocol JJEffectiveBillCellDelegate <NSObject>

- (void)clickToPay:(JJEffectiveBillCell *)sender;

@end

@interface JJEffectiveBillCell : UITableViewCell

@property(nonatomic, strong)UIImageView* statusImg;
@property(nonatomic, strong)UILabel* hotelNameLabel;
@property(nonatomic, strong)UILabel* hotelPriceLabel;
@property(nonatomic, strong)UILabel* contactLabel;
@property(nonatomic, strong)UILabel* inDateLabel;
@property(nonatomic, strong)UILabel* outDateLabel;
@property(nonatomic, strong)UILabel* addressLabel;
@property(nonatomic) BOOL isPayButton;
@property(nonatomic, strong)NSString* orderNo;

@property(nonatomic, strong)JJHotel *hotelInfo;

@property(nonatomic, weak)id<JJEffectiveBillCellDelegate> delegate;

@end

