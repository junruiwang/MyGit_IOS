//
//  RoomFootView.h
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-21.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJPlan.h"
#import "PlanButton.h"
#import "JJHotelRoom.h"

@protocol RoomFootViewDelegate <NSObject>

- (void)getPressedConfirmForm:(HotelPriceConfirmForm *)hotelPriceConfirmForm;

@end

@interface RoomFootView : UIView

@property (nonatomic, strong) UIView *bottomFrameView;
@property (nonatomic, strong) UIView *rightFrameView;
@property (nonatomic, weak) id<RoomFootViewDelegate>  delegate;
@property (nonatomic, strong) JJHotelRoom *room;

- (id)initWithRoom:(JJHotelRoom *)room withKey:(BOOL)isBottom;

@end
