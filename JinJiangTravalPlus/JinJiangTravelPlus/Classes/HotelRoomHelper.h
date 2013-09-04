//
//  HotelRoomHelper.h
//  JinJiangTravelPlus
//
//  Created by jerry on 12-11-28.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJHotel.h"
#import "JJHotelRoom.h"
#import "RoomHeadView.h"
#import "RoomDetailView.h"
#import "UIImageView+WebCache.h"
#import "JJPlan.h"

@protocol HotelRoomHelperDelegate

- (void)performBookControllerView:(NSInteger) dictKey;
- (void)showRoomImage:(UIImage *)imageView;

@end


@interface HotelRoomHelper : NSObject

@property (nonatomic, strong) NSMutableArray* headViewList;
@property (nonatomic, strong) NSMutableArray* detailViewList;
@property (nonatomic, strong) NSMutableArray* roomList;
@property (nonatomic, strong) JJHotel* hotel;
@property (nonatomic, strong) NSMutableDictionary* hotelPriceAskDict;
@property (nonatomic, weak) id<HotelRoomHelperDelegate>  delegate;

- (void)loadRoomViews;

@end
