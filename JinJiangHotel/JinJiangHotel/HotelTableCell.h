//
//  HotelTableCell.h
//  
//
//  Created by Li Peng on 10-8-24.
//  Copyright 2010 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJStarView.h"

#pragma mark - HotelTableCell
@interface HotelTableCell:UITableViewCell

@property (nonatomic, assign) NSInteger hotelId;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *saleHotelImg;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconView;

@property (nonatomic, weak) IBOutlet UILabel *areaLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) JJStarView *starView;

@end

