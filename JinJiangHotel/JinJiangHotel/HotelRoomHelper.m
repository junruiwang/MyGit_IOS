//
//  HotelRoomHelper.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-21.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "HotelRoomHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "HotelPriceConfirmForm.h"

@implementation HotelRoomHelper

@synthesize headViewList;
@synthesize roomList;
@synthesize hotel;
@synthesize hotelPriceAskDict;
@synthesize delegate;

- (id)init
{
    if (self = [super init])
    {
        self.headViewList   = [NSMutableArray array];
        self.hotelPriceAskDict = [[NSMutableDictionary alloc] initWithCapacity:200];
    }
    return self;
}

- (void)loadRoomViews
{
    [self cleanAllArray];
    [self loadHeadViews];
}

- (void)showImage:(UITapGestureRecognizer *)sender
{
    UIImage *bigImage = ((UIImageView *)sender.view).image;
    
    [self.delegate showRoomImage:bigImage];
}
- (void)loadHeadViews
{
    for (unsigned int i=0; i<self.roomList.count; i++)
    {
        JJHotelRoom* room = self.roomList[i];
        
        if (room.planList.count < 1) {
            continue;
        }
        
        RoomHeadView *headView = [[RoomHeadView alloc] initWithHotel:room withKey:i == 0];
        RoomFootView *footView = [[RoomFootView alloc] initWithRoom:room withKey:i == self.roomList.count - 1];
        RoomDetailView *detailView = [[RoomDetailView alloc] initWithContainer:room.infoContainer];
        
        headView.delegate = self;
        footView.delegate = self;
        
        
        [self.headViewList addObject:headView];
        [self.headViewList addObject:detailView];
        [self.headViewList addObject:footView];
    }
}

- (void)getPressedConfirmForm:(HotelPriceConfirmForm *)confirmForm
{
    confirmForm.hotelId = self.hotel.hotelId;
    confirmForm.hotelCode = self.hotel.hotelCode;
    confirmForm.origin = self.hotel.origin;
    confirmForm.hotelName = self.hotel.name;
    confirmForm.hotelBrand = [JJHotel nameForBrand:self.hotel.brand];
    confirmForm.hotelAddress = self.hotel.address;
    confirmForm.coordinate = self.hotel.coordinate;
    
    [self.delegate performBookControllerView:confirmForm];
    
    [self.hotelPriceAskDict setValue:confirmForm
                              forKey:[NSString stringWithFormat:@"%d",confirmForm.planId]];
}

- (void)detailInfoButtonPressed:(RoomHeadView *)roomHeadView
{
    [self.delegate showRoomStyleDetailInfo:roomHeadView];
}

- (void) cleanAllArray
{
    [self.headViewList removeAllObjects];
    [self.detailViewList removeAllObjects];
    [self.hotelPriceAskDict removeAllObjects];
}

@end
