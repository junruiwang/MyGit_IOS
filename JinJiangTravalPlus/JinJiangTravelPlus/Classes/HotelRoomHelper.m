//
//  HotelRoomHelper.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-11-28.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "HotelRoomHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "HotelPriceConfirmForm.h"

@implementation HotelRoomHelper

@synthesize headViewList;
@synthesize detailViewList;
@synthesize roomList;
@synthesize hotel;
@synthesize hotelPriceAskDict;
@synthesize delegate;

- (id)init
{
    if (self = [super init])
    {
        self.headViewList   = [[NSMutableArray alloc] initWithCapacity:50];
        self.detailViewList = [[NSMutableArray alloc] initWithCapacity:50];
        self.hotelPriceAskDict = [[NSMutableDictionary alloc] initWithCapacity:200];
    }
    return self;
}

- (void)loadRoomViews
{
    [self cleanAllArray];
    [self loadHeadViews];
    [self loadDetailViews];
}

- (void)showImage:(UITapGestureRecognizer *)sender
{
    UIImage *bigImage = ((UIImageView *)sender.view).image;
    
    [self.delegate showRoomImage:bigImage];
}
- (void)loadHeadViews

{
    if (self.hotel.origin == JJHotelOriginJJINN || self.hotel.origin == JJHotelOriginBESTAY)
    {
        for (unsigned int i = 0; i < self.roomList.count; i++)
        {
            JJHotelRoom *room = self.roomList[i];
            RoomHeadView *headView = [[RoomHeadView alloc] initWithFrame:CGRectMake(10, 0, 300, 90)];
            headView.section = i;
            UIImageView *roomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 66, 50)];
            [roomImageView setImageWithURL:[NSURL URLWithString:room.imageurl] placeholderImage:[UIImage imageNamed:@"defaultHotelIcon.png"]];
            
            roomImageView.layer.cornerRadius = 3;
            roomImageView.clipsToBounds = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)];
            roomImageView.userInteractionEnabled = YES;
            [roomImageView addGestureRecognizer:tap];
            
            UILabel *roomName = [[UILabel alloc] initWithFrame:CGRectMake(77, 15, 229, 21)];
            roomName.text = room.name;
            roomName.font = [UIFont systemFontOfSize:18];
            roomName.textColor = RGBCOLOR(3,86,126);
            roomName.backgroundColor = [UIColor clearColor];
            [headView addSubview:roomImageView];
            [headView addSubview:roomName];
            [self extractedHeadView:headView room:room];
            [self.headViewList addObject:headView];
        }
    }
    else
    {
        for (unsigned int i=0; i<self.roomList.count; i++)
        {
            JJHotelRoom* room = self.roomList[i];

            JJPlan* lastPlan = [room.planList objectAtIndex:(room.planList.count-1)];
            CGSize stringSize = [lastPlan.planName sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(140, 30)
                                                  lineBreakMode:UILineBreakModeWordWrap];
            float totalHeight = (room.planList.count)*36 + 65;
            if (stringSize.height == 15) {  totalHeight = totalHeight - 12; }
            RoomHeadView *headView = [[RoomHeadView alloc] initWithFrame:CGRectMake(10, 0, 300, totalHeight)];
            headView.section = i;
            UIImageView *roomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 6, 66, 50)];
            [roomImageView setImageWithURL:[NSURL URLWithString:room.imageurl] placeholderImage:[UIImage imageNamed:@"defaultHotelIcon.png"]];
            
            roomImageView.layer.cornerRadius = 3;
            roomImageView.clipsToBounds = YES;
            
            UILabel *roomName = [[UILabel alloc] initWithFrame:CGRectMake(77, 15, 229, 21)];
            roomName.text = room.name;
            roomName.font = [UIFont systemFontOfSize:18];
            roomName.textColor = RGBCOLOR(3,86,126);
            roomName.backgroundColor = [UIColor clearColor];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)];
            roomImageView.userInteractionEnabled = YES;
            [roomImageView addGestureRecognizer:tap];
//            UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            imageBtn.frame = CGRectMake(5, 5, 66, 50);
//            [imageBtn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
//            [headView addSubview:imageBtn];
            
            [headView addSubview:roomImageView];
            [headView addSubview:roomName];
            [self extractedStarHeadView:room headView:headView];
            [self.headViewList addObject:headView];
        }
    }
}

- (void)extractedHeadView:(RoomHeadView *)headView room:(JJHotelRoom *)room
{
    BOOL isAvaiable = NO;
    if (room.planList.count==1)
    {
        JJPlan* plan = [room.planList objectAtIndex:0];
        if (plan.roomAvai)
        {
            isAvaiable = YES;
            [self addPriceConfirmFormToDict:plan roomInfo:room];
        }
        UILabel *rateName = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 52, 15)];
        rateName.text = plan.planName;
        rateName.font = [UIFont systemFontOfSize:12];
        rateName.textColor = [UIColor darkGrayColor];
        rateName.backgroundColor = [UIColor clearColor];
        [headView addSubview:rateName];

        UILabel *symbol = [[UILabel alloc] initWithFrame:CGRectMake(78, 62, 8, 18)];
        symbol.text = @"¥";
        symbol.font = [UIFont boldSystemFontOfSize:12];
        symbol.textColor = RGBCOLOR(255,110,34);
        symbol.backgroundColor = [UIColor clearColor];
        [headView addSubview:symbol];

        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(87, 60, 44, 21)];
        price.text = [NSString stringWithFormat:@"%d",plan.price];
        price.font = [UIFont boldSystemFontOfSize:17];
        price.textColor = RGBCOLOR(255,110,34);
        price.backgroundColor = [UIColor clearColor];
        [headView addSubview:price];
    }
    else if (room.planList.count==2)
    {
        for (unsigned int i=0; i<room.planList.count; i++)
        {
            JJPlan *plan = [room.planList objectAtIndex:i];
            if (plan.roomAvai)
            {
                isAvaiable = YES;
                [self addPriceConfirmFormToDict:plan roomInfo:room];
            }

            if ([plan.rateCode caseInsensitiveCompare:@"SCard"] == NSOrderedSame)
            {
                UILabel *rateName = [[UILabel alloc] initWithFrame:CGRectMake(5, 65, 52, 15)];
                rateName.text = plan.planName;
                rateName.font = [UIFont systemFontOfSize:12];
                rateName.textColor = [UIColor darkGrayColor];
                rateName.backgroundColor = [UIColor clearColor];
                [headView addSubview:rateName];

                UILabel *symbol = [[UILabel alloc] initWithFrame:CGRectMake(58, 64, 8, 18)];
                symbol.text = @"¥";
                symbol.font = [UIFont boldSystemFontOfSize:12];
                symbol.textColor = RGBCOLOR(50,157,209);
                symbol.backgroundColor = [UIColor clearColor];
                [headView addSubview:symbol];

                UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(67, 62, 44, 21)];
                price.text = [NSString stringWithFormat:@"%d",plan.price];
                price.font = [UIFont boldSystemFontOfSize:17];
                price.textColor = RGBCOLOR(50,157,209);
                price.backgroundColor = [UIColor clearColor];
                [headView addSubview:price];
            }
            else if ([plan.rateCode caseInsensitiveCompare:@"Rcard"] == NSOrderedSame)
            {
                UILabel *rateName = [[UILabel alloc] initWithFrame:CGRectMake(115, 65, 40, 15)];
                rateName.text = plan.planName;
                rateName.font = [UIFont systemFontOfSize:12];
                rateName.textColor = [UIColor darkGrayColor];
                rateName.backgroundColor = [UIColor clearColor];
                [headView addSubview:rateName];

                UILabel *symbol = [[UILabel alloc] initWithFrame:CGRectMake(156, 64, 8, 18)];
                symbol.text = @"¥";
                symbol.font = [UIFont boldSystemFontOfSize:12];
                symbol.textColor = RGBCOLOR(255,110,34);
                symbol.backgroundColor = [UIColor clearColor];
                [headView addSubview:symbol];

                UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(165, 62, 44, 21)];
                price.text = [NSString stringWithFormat:@"%d",plan.price];
                price.font = [UIFont boldSystemFontOfSize:17];
                price.textColor = RGBCOLOR(255,110,34);
                price.backgroundColor = [UIColor clearColor];
                [headView addSubview:price];
            }
        }
    }
    UIButton *bookBtn = [[UIButton alloc] initWithFrame:CGRectMake(240, 55, 60, 30)];
    if (isAvaiable)
    {
        [bookBtn setTag:room.roomId];
        [bookBtn setBackgroundImage:[UIImage imageNamed:@"book.png"] forState:(UIControlStateNormal)];
        [bookBtn setBackgroundImage:[UIImage imageNamed:@"book-1.png"] forState:(UIControlStateHighlighted)];
        [bookBtn addTarget:self action:@selector(bookHotel:) forControlEvents:UIControlEventTouchUpInside |UIControlEventTouchUpOutside];
    }
    else
    {
        [bookBtn setBackgroundImage:[UIImage imageNamed:@"book-2.png"] forState:(UIControlStateNormal)];
        [bookBtn setEnabled:NO];
    }
    [headView addSubview:bookBtn];
}


-(void)bookHotel:(id) sender
{
    UIButton *bookBtn = (UIButton *)sender;
    [self.delegate performBookControllerView:bookBtn.tag];
}

- (void)extractedStarHeadView:(JJHotelRoom *)room headView:(RoomHeadView *)headView
{
    NSMutableArray *planList = room.planList;
    for (unsigned int i = 0; i < [planList count]; i++)
    {
        JJPlan *plan = [planList objectAtIndex:i];
        CGSize stringSize = [plan.planName sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(140, 30)
                                          lineBreakMode:UILineBreakModeWordWrap];
        UILabel *rateName = [[UILabel alloc] initWithFrame:CGRectMake(5, 60+(36*i), stringSize.width, stringSize.height)];
        rateName.lineBreakMode = UILineBreakModeWordWrap;
        rateName.numberOfLines = 0;
        rateName.text = plan.planName;
        rateName.font = [UIFont systemFontOfSize:12];
        rateName.textColor = [UIColor darkGrayColor];
        rateName.backgroundColor = [UIColor clearColor];
        [headView addSubview:rateName];
        
        UILabel *breakFast = [[UILabel alloc] initWithFrame:CGRectMake(145, 60+(36*i), 40, 16)];
        switch (plan.breakfast)
        {
            case JJBreakfastNone:
            {   breakFast.text = @"无早";
                break;
            }
            case JJBreakfastSingle:
            {   breakFast.text = @"单早";
                break;
            }
            case JJBreakfastDouble:
            {   breakFast.text = @"双早";
                break;
            }
            default:    {   break;  }
        }
        breakFast.font = [UIFont systemFontOfSize:12];
        breakFast.textColor = [UIColor darkGrayColor];
        breakFast.backgroundColor = [UIColor clearColor];
        [headView addSubview:breakFast];
        
        UILabel *symbol = [[UILabel alloc] initWithFrame:CGRectMake(178, 60+(36*i), 8, 18)];
        symbol.text = @"¥";
        symbol.font = [UIFont boldSystemFontOfSize:12];
        symbol.textColor = RGBCOLOR(255,110,34);
        symbol.backgroundColor = [UIColor clearColor];
        [headView addSubview:symbol];

        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(186, 60+(36*i)-2, 48, 21)];
        price.text = [NSString stringWithFormat:@"%d",plan.price];
        price.font = [UIFont boldSystemFontOfSize:17];
        price.textColor = RGBCOLOR(255,110,34);
        price.backgroundColor = [UIColor clearColor];
        [headView addSubview:price];

        UIButton *bookBtn = [[UIButton alloc] initWithFrame:CGRectMake(240, 55+(36*i)-2, 60, 30)];
        if (plan.roomAvai)
        {
            [self addPriceConfirmFormToDict:plan roomInfo:room];
            bookBtn.tag = plan.planId;
            [bookBtn setBackgroundImage:[UIImage imageNamed:@"book.png"] forState:(UIControlStateNormal)];
            [bookBtn setBackgroundImage:[UIImage imageNamed:@"book-1.png"] forState:(UIControlStateHighlighted)];
            [bookBtn addTarget:self action:@selector(bookHotel:) forControlEvents:UIControlEventTouchUpInside |UIControlEventTouchUpOutside];
        }
        else
        {
            [bookBtn setBackgroundImage:[UIImage imageNamed:@"book-2.png"] forState:(UIControlStateNormal)];
            bookBtn.enabled = NO;
        }
        [headView addSubview:bookBtn];
    }
}

- (void)loadDetailViews
{
    for (unsigned int i = 0; i < self.roomList.count; i++)
    {
        JJHotelRoom *room = self.roomList[i];
        RoomDetailView * detailView = [[RoomDetailView alloc] initWithFrame:CGRectMake(10, 0, 300, 40)];
        detailView.roomId = room.roomId;
        const float ySize = [self addLabelsToView:detailView room:room];
        detailView.frame = CGRectMake(0, 0, 300, ySize);
        [self.detailViewList addObject:detailView];
    }
}

- (float) addLabelsToView:(RoomDetailView *) detailView room:(JJHotelRoom *) hotelRoom
{
    UIFont *font = [UIFont systemFontOfSize:12];
    UIColor *textColor = [UIColor darkGrayColor];
    RoomInfoContainer *infoContainer = hotelRoom.infoContainer;
    float contentHeight = 0;
    if (self.hotel.brand == JJHotelBrandJJHOTEL || self.hotel.brand == JJHotelBrandSHANGYUE) {
        //床型
        UIImageView *bedTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 13, 13)];
        bedTypeImageView.image = [UIImage imageNamed:@"room_bed.png"];
        [detailView addSubview:bedTypeImageView];
        
        UILabel *bedTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, 120, 20)];
        bedTypeLabel.font = font;
        bedTypeLabel.textColor = textColor;
        bedTypeLabel.text = infoContainer.bedType;
        bedTypeLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:bedTypeLabel];
        
        //面积
        UIImageView *areaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 4, 13, 13)];
        areaImageView.image = [UIImage imageNamed:@"room_area.png"];
        [detailView addSubview:areaImageView];
        
        UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(177, 0, 120, 20)];
        areaLabel.font = font;
        areaLabel.textColor = textColor;
        areaLabel.text = infoContainer.roomArea;
        areaLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:areaLabel];
        
        //所在楼层
        UIImageView *floorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 24, 13, 13)];
        floorImageView.image = [UIImage imageNamed:@"room_floor.png"];
        [detailView addSubview:floorImageView];
        
        UILabel *floorLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 20, 120, 20)];
        floorLabel.font = font;
        floorLabel.textColor = textColor;
        floorLabel.text = infoContainer.floor;
        floorLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:floorLabel];
        
        //加床
        UIImageView *extraBedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 24, 13, 13)];
        extraBedImageView.image = [UIImage imageNamed:@"room_bed.png"];
        [detailView addSubview:extraBedImageView];
        
        UILabel *extraBedLabel = [[UILabel alloc] initWithFrame:CGRectMake(177, 20, 120, 20)];
        extraBedLabel.font = font;
        extraBedLabel.textColor = textColor;
        extraBedLabel.text = infoContainer.extraBed;
        extraBedLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:extraBedLabel];
        
        //宽带上网
        UIImageView *wlanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 44, 13, 13)];
        wlanImageView.image = [UIImage imageNamed:@"room_wifi.png"];
        [detailView addSubview:wlanImageView];
        
        UILabel *wlanLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 40, 120, 20)];
        wlanLabel.font = font;
        wlanLabel.textColor = textColor;
        wlanLabel.text = [NSString stringWithFormat:@"%@ %@", infoContainer.wlan, infoContainer.charge];
        wlanLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:wlanLabel];
        
        //无烟房
        UIImageView *smokingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 44, 13, 13)];
        smokingImageView.image = [UIImage imageNamed:@"room_smoking.png"];
        [detailView addSubview:smokingImageView];
        
        UILabel *smokingLabel = [[UILabel alloc] initWithFrame:CGRectMake(177, 40, 120, 20)];
        smokingLabel.font = font;
        smokingLabel.textColor = textColor;
        smokingLabel.text = infoContainer.nonSmokingRoom;
        smokingLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:smokingLabel];
        
        contentHeight = 65;
        //其他事项
        NSString *otherBusiness = [infoContainer.otherBusiness stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (![otherBusiness isEqualToString:@""]) {            
            UILabel *otherBusinessLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 64, 280, 15)];
            otherBusinessLabel.numberOfLines = 0;
            otherBusinessLabel.lineBreakMode = UILineBreakModeCharacterWrap;
            otherBusinessLabel.font = font;
            otherBusinessLabel.textColor = textColor;
            otherBusinessLabel.text = [NSString stringWithFormat:@"其他事项：%@", otherBusiness];
            otherBusinessLabel.backgroundColor = [UIColor clearColor];
            [otherBusinessLabel sizeToFit];
            [detailView addSubview:otherBusinessLabel];
            contentHeight = 75 + otherBusinessLabel.frame.size.height;
        }
        
    } else if (self.hotel.brand == JJHotelBrandJJINN || self.hotel.brand == JJHotelBrandJG) {
        //床型
        UIImageView *bedTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 13, 13)];
        bedTypeImageView.image = [UIImage imageNamed:@"room_bed.png"];
        [detailView addSubview:bedTypeImageView];
        
        UILabel *bedTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, 120, 20)];
        bedTypeLabel.font = font;
        bedTypeLabel.textColor = textColor;
        bedTypeLabel.text = infoContainer.bedType;
        bedTypeLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:bedTypeLabel];
        
        //面积
        UIImageView *areaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 4, 13, 13)];
        areaImageView.image = [UIImage imageNamed:@"room_area.png"];
        [detailView addSubview:areaImageView];
        
        UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(177, 0, 120, 20)];
        areaLabel.font = font;
        areaLabel.textColor = textColor;
        areaLabel.text = infoContainer.roomArea;
        areaLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:areaLabel];
        
        JJPlan *plan = [hotelRoom.planList objectAtIndex:0];
        NSString *breakFast = @"";
        switch (plan.breakfast)
        {
            case JJBreakfastNone:
            {
                breakFast = @"无";
                break;
            }
            case JJBreakfastSingle:
            {
                breakFast = @"单早";
                break;
            }
            case JJBreakfastDouble:
            {
                breakFast = @"双早";
                break;
            }
        }
        //早餐
        UIImageView *breakFastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 24, 13, 13)];
        breakFastImageView.image = [UIImage imageNamed:@"room_breakfast.png"];
        [detailView addSubview:breakFastImageView];
        
        UILabel *breakFastLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 20, 120, 20)];
        breakFastLabel.font = font;
        breakFastLabel.textColor = textColor;
        breakFastLabel.text = breakFast;
        breakFastLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:breakFastLabel];
        
        NSString* wlan = plan.network ? @"免费" : @"收费";
        //宽带
        UIImageView *wlanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 24, 13, 13)];
        wlanImageView.image = [UIImage imageNamed:@"room_wifi.png"];
        [detailView addSubview:wlanImageView];
        
        UILabel *wlanLabel = [[UILabel alloc] initWithFrame:CGRectMake(177, 20, 120, 20)];
        wlanLabel.font = font;
        wlanLabel.textColor = textColor;
        wlanLabel.text = wlan;
        wlanLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:wlanLabel];
        
        //是否临街
        UIImageView *frontageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 44, 13, 13)];
        frontageImageView.image = [UIImage imageNamed:@"room_frontage.png"];
        [detailView addSubview:frontageImageView];
        
        UILabel *frontageLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 40, 120, 20)];
        frontageLabel.font = font;
        frontageLabel.textColor = textColor;
        frontageLabel.text = infoContainer.frontage;
        frontageLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:frontageLabel];
        
        //是否暗房
        UIImageView *windowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 44, 13, 13)];
        windowImageView.image = [UIImage imageNamed:@"room_window.png"];
        [detailView addSubview:windowImageView];
        
        UILabel *windowLabel = [[UILabel alloc] initWithFrame:CGRectMake(177, 40, 120, 20)];
        windowLabel.font = font;
        windowLabel.textColor = textColor;
        windowLabel.text = infoContainer.window;
        windowLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:windowLabel];
        
        contentHeight = 65;
    } else if (self.hotel.brand == JJHotelBrandBESTAY) {
        //床型
        UIImageView *bedTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 13, 13)];
        bedTypeImageView.image = [UIImage imageNamed:@"room_bed.png"];
        [detailView addSubview:bedTypeImageView];
        
        UILabel *bedTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, 120, 20)];
        bedTypeLabel.font = font;
        bedTypeLabel.textColor = textColor;
        bedTypeLabel.text = infoContainer.bedType;
        bedTypeLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:bedTypeLabel];
        
        //可入住人数
        UIImageView *guestsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 4, 13, 13)];
        guestsImageView.image = [UIImage imageNamed:@"room_guests.png"];
        [detailView addSubview:guestsImageView];
        
        UILabel *guestsLabel = [[UILabel alloc] initWithFrame:CGRectMake(177, 0, 120, 20)];
        guestsLabel.font = font;
        guestsLabel.textColor = textColor;
        guestsLabel.text = infoContainer.guests;
        guestsLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:guestsLabel];
        
        JJPlan *plan = [hotelRoom.planList objectAtIndex:0];
        //早餐
        NSString *breakFast = @"";
        switch (plan.breakfast)
        {
            case JJBreakfastNone:
            {
                breakFast = @"无";
                break;
            }
            case JJBreakfastSingle:
            {
                breakFast = @"单早";
                break;
            }
            case JJBreakfastDouble:
            {
                breakFast = @"双早";
                break;
            }
        }
        UIImageView *breakFastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 24, 13, 13)];
        breakFastImageView.image = [UIImage imageNamed:@"room_breakfast.png"];
        [detailView addSubview:breakFastImageView];
        
        UILabel *breakFastLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 20, 120, 20)];
        breakFastLabel.font = font;
        breakFastLabel.textColor = textColor;
        breakFastLabel.text = breakFast;
        breakFastLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:breakFastLabel];
        
        //宽带
        NSString* wlan = plan.network ? @"免费" : @"收费";
        UIImageView *wlanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 24, 13, 13)];
        wlanImageView.image = [UIImage imageNamed:@"room_wifi.png"];
        [detailView addSubview:wlanImageView];
        
        UILabel *wlanLabel = [[UILabel alloc] initWithFrame:CGRectMake(177, 20, 120, 20)];
        wlanLabel.font = font;
        wlanLabel.textColor = textColor;
        wlanLabel.text = wlan;
        wlanLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:wlanLabel];
        
        contentHeight = 45;
    } else if (self.hotel.brand == JJHotelBrandBYL) {
        JJPlan *plan = [hotelRoom.planList objectAtIndex:0];
        NSString *breakFast = @"";
        switch (plan.breakfast)
        {
            case JJBreakfastNone:
            {
                breakFast = @"无";
                break;
            }
            case JJBreakfastSingle:
            {
                breakFast = @"单早";
                break;
            }
            case JJBreakfastDouble:
            {
                breakFast = @"双早";
                break;
            }
        }
        //早餐
        UIImageView *breakFastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 13, 13)];
        breakFastImageView.image = [UIImage imageNamed:@"room_breakfast.png"];
        [detailView addSubview:breakFastImageView];
        
        UILabel *breakFastLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, 120, 20)];
        breakFastLabel.font = font;
        breakFastLabel.textColor = textColor;
        breakFastLabel.text = breakFast;
        breakFastLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:breakFastLabel];
        
        NSString* wlan = plan.network ? @"免费" : @"收费";
        //宽带
        UIImageView *wlanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 4, 13, 13)];
        wlanImageView.image = [UIImage imageNamed:@"room_wifi.png"];
        [detailView addSubview:wlanImageView];
        
        UILabel *wlanLabel = [[UILabel alloc] initWithFrame:CGRectMake(177, 0, 120, 20)];
        wlanLabel.font = font;
        wlanLabel.textColor = textColor;
        wlanLabel.text = wlan;
        wlanLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:wlanLabel];
        
        contentHeight = 25;
    }
    
    return contentHeight;
}

- (void) addPriceConfirmFormToDict:(JJPlan *)plan roomInfo:(JJHotelRoom *) room
{
    HotelPriceConfirmForm *priceConfirmForm = [[HotelPriceConfirmForm alloc] init];
    priceConfirmForm.hotelId = self.hotel.hotelId;
    priceConfirmForm.hotelCode = self.hotel.hotelCode;
    priceConfirmForm.origin = self.hotel.origin;
    priceConfirmForm.hotelName = self.hotel.name;
    priceConfirmForm.roomId = room.roomId;
    priceConfirmForm.roomName = room.name;
    priceConfirmForm.rateCode = plan.rateCode;
    priceConfirmForm.planId = plan.planId;
    priceConfirmForm.hotelBrand = [JJHotel nameForBrand:self.hotel.brand];
    priceConfirmForm.hotelAddress = self.hotel.address;
    priceConfirmForm.coordinate = self.hotel.coordinate;
    
    [self.hotelPriceAskDict setValue:priceConfirmForm
                              forKey:[NSString stringWithFormat:@"%d",plan.planId]];
}

- (void) cleanAllArray
{
    [self.headViewList removeAllObjects];
    [self.detailViewList removeAllObjects];
    [self.hotelPriceAskDict removeAllObjects];
}

@end
