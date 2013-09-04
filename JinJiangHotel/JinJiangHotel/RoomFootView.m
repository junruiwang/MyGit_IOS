//
//  RoomFootView.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-21.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "RoomFootView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoomFootView


- (id)initWithRoom:(JJHotelRoom *)room withKey:(BOOL)isBottom
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 42 * room.planList.count)]) {
        
        self.room = room;
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, 306, 7)];
        whiteView.backgroundColor = [UIColor whiteColor];
        
        if (isBottom) {
            
            self.rightFrameView = [[UIView alloc] initWithFrame:CGRectMake(306, 0, 1, 42 * room.planList.count - 4)];
            self.rightFrameView.layer.borderColor = RGBCOLOR(240, 210, 151).CGColor;
            
            self.bottomFrameView = [[UIView alloc] initWithFrame:CGRectMake(-8, 0, 315, self.frame.size.height)];
            self.bottomFrameView.layer.cornerRadius = 8;
            self.bottomFrameView.layer.borderColor = RGBCOLOR(240, 210, 151).CGColor;
        } else {
            
            self.rightFrameView = [[UIView alloc] initWithFrame:CGRectMake(306, 0, 1, 42 * room.planList.count)];
            self.rightFrameView.layer.borderColor = RGBCOLOR(240, 210, 151).CGColor;
            
            self.bottomFrameView = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, 308, self.frame.size.height)];
            self.bottomFrameView.layer.borderColor = RGBCOLOR(240, 210, 151).CGColor;
        }
        
        self.rightFrameView.layer.borderWidth = 1;
        self.bottomFrameView.layer.borderWidth = 1;
        
        self.bottomFrameView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.rightFrameView];
        [self addSubview:self.bottomFrameView];
        [self addSubview:whiteView];
        
        for (int i = 0; i < room.planList.count; i++) {
            id plan = [room.planList objectAtIndex:i];
            if (![plan isKindOfClass:[JJPlan class]]) {
                return self;
            }
            
            JJPlan *aPlan = (JJPlan *)plan;
            
            UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 180, 42)];
            detail.text = aPlan.planName;
            detail.font = [UIFont systemFontOfSize:12];
            detail.textColor = RGBCOLOR(160, 140, 25);
            detail.backgroundColor = [UIColor clearColor];
            
            UILabel *breakFast = [[UILabel alloc] initWithFrame:CGRectMake(190, 0, 40, 42)];
            breakFast.font = [UIFont systemFontOfSize:12];
            breakFast.textColor = RGBCOLOR(160, 140, 25);
            breakFast.backgroundColor = [UIColor clearColor];
            
            switch (aPlan.breakfast)
            {
                case JJBreakfastNone:
                {   breakFast.text = NSLocalizedStringFromTable(@"no breakfast", @"HotelDetail", @"");
                    break;
                }
                case JJBreakfastSingle:
                {   breakFast.text = NSLocalizedStringFromTable(@"single breakfast", @"HotelDetail", @"");;
                    break;
                }
                case JJBreakfastDouble:
                {   breakFast.text = NSLocalizedStringFromTable(@"double breakfast", @"HotelDetail", @"");;
                    break;
                }
                default:
                    break;
            }
            
            PlanButton *priceButton = [PlanButton buttonWithType:UIButtonTypeCustom];
            priceButton.frame = CGRectMake(238, -1, 75, 39);
            priceButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"price_label.png"]];
            [priceButton addTarget:self action:@selector(planPressed:) forControlEvents:UIControlEventTouchUpInside];
            priceButton.hotelPriceConfirmForm = [self transformHotelPriceConfirmFormByPlan:plan andRoom:room];
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(238, 8, 75, 31)];
            priceLabel.text = [NSString stringWithFormat:@"%@ %i",NSLocalizedStringFromTable(@"dolor symble", @"HotelDetail", @""), aPlan.price];
            priceLabel.font = [UIFont fontWithName:@"Georgia" size:18];
            priceLabel.textColor = [UIColor blackColor];
            priceLabel.backgroundColor = [UIColor clearColor];
            priceLabel.textAlignment = NSTextAlignmentCenter;
            
            UIView *planView = [[UIView alloc] initWithFrame:CGRectMake(0, i * 42, 320, 42)];
            [planView addSubview:detail];
            [planView addSubview:breakFast];
            [planView addSubview:priceButton];
            [planView addSubview:priceLabel];
            
            [self addSubview:planView];
        }
    }
    return self;
}

- (HotelPriceConfirmForm *)transformHotelPriceConfirmFormByPlan:(JJPlan *)plan andRoom:(JJHotelRoom *)room
{
    HotelPriceConfirmForm *priceConfirmForm = [[HotelPriceConfirmForm alloc] init];
//    priceConfirmForm.hotelId = self.hotel.hotelId;
//    priceConfirmForm.hotelCode = self.hotel.hotelCode;
//    priceConfirmForm.origin = self.hotel.origin;
//    priceConfirmForm.hotelName = self.hotel.name;
    priceConfirmForm.roomId = room.roomId;
    priceConfirmForm.roomName = room.name;
    priceConfirmForm.rateCode = plan.rateCode;
    priceConfirmForm.planId = plan.planId;
    priceConfirmForm.imageUrl = room.imageurl;
//    priceConfirmForm.hotelBrand = [JJHotel nameForBrand:self.hotel.brand];
//    priceConfirmForm.hotelAddress = self.hotel.address;
//    priceConfirmForm.coordinate = self.hotel.coordinate;
    return priceConfirmForm;
}

- (void)planPressed:(PlanButton *)sender
{
    [self.delegate getPressedConfirmForm:sender.hotelPriceConfirmForm];
}
@end
