//
//  RoomDetailView.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-21.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "RoomDetailView.h"

@implementation RoomDetailView


- (id)initWithContainer:(RoomInfoContainer *)container
{
    if (self = [super initWithFrame:CGRectMake(0, 60, 306, 71)]) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -6, 307, 76)];
        backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"room_style_detail_bg.png"]];
        [self addSubview:backgroundView];
        
        UIImageView *bed = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bed.png"]];
        bed.frame = CGRectMake(17, 9, 13, 13);
        
        UILabel *bedLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 9, 137, 13)];
        bedLabel.font = [UIFont systemFontOfSize:12];
        bedLabel.textColor = RGBCOLOR(67, 67, 67);
        bedLabel.text = container.bedType;
        bedLabel.backgroundColor = [UIColor clearColor];
        
        UIImageView *floor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_floor.png"]];
        floor.frame = CGRectMake(17, 28, 13, 13);
        
        UILabel *floorLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 28, 137, 13)];
        floorLabel.font = [UIFont systemFontOfSize:12];
        floorLabel.textColor = RGBCOLOR(67, 67, 67);
        floorLabel.text = container.floor;
        floorLabel.backgroundColor = [UIColor clearColor];
        
        UIImageView *wifi = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_WIFI.png"]];
        wifi.frame = CGRectMake(17, 47, 13, 13);
        
        UILabel *wifiLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 47, 137, 13)];
        wifiLabel.font = [UIFont systemFontOfSize:12];
        wifiLabel.textColor = RGBCOLOR(67, 67, 67);
        wifiLabel.text = container.wlan;
        wifiLabel.backgroundColor = [UIColor clearColor];
        
        UIImageView *square = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_square.png"]];
        square.frame = CGRectMake(157, 9, 13, 13);
        
        UILabel *squareLabel = [[UILabel alloc] initWithFrame:CGRectMake(173, 9, 137, 13)];
        squareLabel.font = [UIFont systemFontOfSize:12];
        squareLabel.textColor = RGBCOLOR(67, 67, 67);
        squareLabel.text = container.roomArea;
        squareLabel.backgroundColor = [UIColor clearColor];
        
        UIImageView *addBed = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_add_bed.png"]];
        addBed.frame = CGRectMake(157, 28, 13, 13);
        
        UILabel *addBedLabel = [[UILabel alloc] initWithFrame:CGRectMake(173, 28, 137, 13)];
        addBedLabel.font = [UIFont systemFontOfSize:12];
        addBedLabel.textColor = RGBCOLOR(67, 67, 67);
        addBedLabel.text = container.extraBed;
        addBedLabel.backgroundColor = [UIColor clearColor];
        
        UIImageView *noSmoke = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_no_smoke.png"]];
        noSmoke.frame = CGRectMake(157, 47, 13, 13);
        
        UILabel *noSmokeLabel = [[UILabel alloc] initWithFrame:CGRectMake(173, 47, 137, 13)];
        noSmokeLabel.font = [UIFont systemFontOfSize:12];
        noSmokeLabel.textColor = RGBCOLOR(67, 67, 67);
        noSmokeLabel.text = container.nonSmokingRoom;
        noSmokeLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:bed];
        [self addSubview:floor];
        [self addSubview:wifi];
        [self addSubview:square];
        [self addSubview:addBed];
        [self addSubview:noSmoke];
        
        [self addSubview:bedLabel];
        [self addSubview:floorLabel];
        [self addSubview:wifiLabel];
        [self addSubview:squareLabel];
        [self addSubview:addBedLabel];
        [self addSubview:noSmokeLabel];
        
    }
    return self;
}

@end
