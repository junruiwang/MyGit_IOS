//
//  HotelTableCell.h
//  
//
//  Created by Li Peng on 10-8-24.
//  Copyright 2010 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJStarView.h"
#import "PrettyTableViewCell.h"

#pragma mark - HotelTableCell

@interface HotelTableCell : PrettyTableViewCell

@property (nonatomic, assign) NSInteger hotelId;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *fenLabel;
@property (nonatomic, strong) UILabel *hotelRateLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *dollarLabel;
@property (nonatomic, strong) JJStarView *starView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UILabel *soldoutLabel;
@property (nonatomic, strong) UILabel *upLabel;

@end

#pragma mark - HotelDetailTableCell

@interface HotelDetailTableCell : PrettyTableViewCell

@end
