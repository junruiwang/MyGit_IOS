//
//  HotelRoomHelper.h
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-21.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJHotel.h"
#import "JJHotelRoom.h"
#import "RoomHeadView.h"
#import "RoomFootView.h"
#import "RoomDetailView.h"
#import "UIImageView+WebCache.h"
#import "JJPlan.h"

@protocol HotelRoomHelperDelegate

- (void)performBookControllerView:(HotelPriceConfirmForm *) confirmForm;
- (void)showRoomImage:(UIImage *)imageView;
- (void)showRoomStyleDetailInfo:(RoomHeadView *)headView;

@end


@interface HotelRoomHelper : NSObject <RoomFootViewDelegate, RoomHeadViewDelegate>

@property (nonatomic, strong) NSMutableArray* headViewList;
@property (nonatomic, strong) NSMutableArray* detailViewList;
@property (nonatomic, strong) NSMutableArray *footViewList;
@property (nonatomic, strong) NSMutableArray* roomList;
@property (nonatomic, strong) JJHotel* hotel;
@property (nonatomic, strong) NSMutableDictionary* hotelPriceAskDict;
@property (nonatomic, weak) id<HotelRoomHelperDelegate>  delegate;

- (void)loadRoomViews;

@end
