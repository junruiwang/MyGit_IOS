//
//  FaverateCell.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 13-1-16.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FaverateCellIdentifier  @"FaverateCellIdentifier"
#define FaverateSectionreuseIdentifier @"FaverateSectionreuseIdentifier"

@interface FaverateCell : UITableViewCell

@property(nonatomic) unsigned int hotelID;
@property(nonatomic, strong)UIImageView* brandImg;
@property(nonatomic, strong)UIImageView* img;

@end
