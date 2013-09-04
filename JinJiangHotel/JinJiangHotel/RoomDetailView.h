//
//  RoomDetailView.h
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-21.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomInfoContainer.h"

@interface RoomDetailView : UIView

@property(nonatomic) int roomId;

- (id)initWithContainer:(RoomInfoContainer *)container;

@end
