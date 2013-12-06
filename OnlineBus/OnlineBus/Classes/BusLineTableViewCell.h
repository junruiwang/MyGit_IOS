//
//  BusLineTableViewCell.h
//  Bustime
//
//  Created by jerry on 13-4-1.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusLineTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *lineNameLabel;
@property(nonatomic, weak) IBOutlet UILabel *stationLabel;
@property(nonatomic, weak) IBOutlet UILabel *lineDescLabel;
@property(nonatomic, weak) IBOutlet UIImageView *sepView;

@end
