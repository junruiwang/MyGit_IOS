//
//  RoomHeadView.h
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-21.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJHotelRoom.h"

@class RoomHeadView;
@protocol RoomHeadViewDelegate <NSObject>

- (void)detailInfoButtonPressed:(RoomHeadView *)roomHeadView;

@end

@interface RoomHeadView : UIView

@property (nonatomic) NSUInteger section;
@property (nonatomic, strong) JJHotelRoom *room;
@property (nonatomic) BOOL isDetailOpen;
@property (nonatomic, strong) UIView *rightFrameView;
@property (nonatomic, strong) UIView *topFrameView;
@property (nonatomic, weak) id<RoomHeadViewDelegate> delegate;

- (id)initWithHotel:(JJHotelRoom *)room withKey:(BOOL)isTop;

@end
