//
//  RoomHeadView.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-21.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "RoomHeadView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoomHeadView

- (id)initWithHotel:(JJHotelRoom *)room withKey:(BOOL)isTop
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 60)];
    if (self) {
        self.isDetailOpen = NO;
        self.room = room;
        self.backgroundColor = [UIColor clearColor];
        if (isTop) {
            self.topFrameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 307, 40)];
            self.topFrameView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"room_detail_head.png"]];
            UIView *blankBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 307, 20)];
            blankBackground.backgroundColor = [UIColor whiteColor];
            
            [self addSubview:blankBackground];
            
            self.rightFrameView = [[UIView alloc] initWithFrame:CGRectMake(306, 7, 1, 53)];
            
        } else {
            self.topFrameView = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, 308, 60)];
            self.topFrameView.backgroundColor = [UIColor whiteColor];
            
            self.rightFrameView = [[UIView alloc] initWithFrame:CGRectMake(306, 0, 1, 60)];
        }
        
        self.rightFrameView.layer.borderWidth = 1;
        self.rightFrameView.layer.borderColor = RGBCOLOR(240, 210, 151).CGColor;
        
        UIImageView *roomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 3, 70, 52)];
        [roomImageView setImageWithURL:[NSURL URLWithString:room.imageurl] placeholderImage:[UIImage imageNamed:@"defaultHotelIcon.png"]];
        roomImageView.clipsToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)];
        roomImageView.userInteractionEnabled = YES;
        [roomImageView addGestureRecognizer:tap];
        
        UILabel *roomName = [[UILabel alloc] initWithFrame:CGRectMake(99, 11, 200, 20)];
        roomName.text = room.name;
        roomName.font = [UIFont systemFontOfSize:15];
        roomName.textColor = [UIColor blackColor];
        roomName.backgroundColor = [UIColor clearColor];
        
        UIButton *roomDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        roomDetailButton.frame = CGRectMake(93, 37, 81, 21);
        [roomDetailButton setImage:[UIImage imageNamed:@"room_style_desc.png"] forState:UIControlStateNormal];
        [roomDetailButton addTarget:self action:@selector(detailInfoPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.topFrameView];
        [self addSubview:self.rightFrameView];
        [self addSubview:roomDetailButton];
        [self addSubview:roomImageView];
        [self addSubview:roomName];
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}

- (void)detailInfoPressed:(UIButton *)sender
{
    [self.delegate detailInfoButtonPressed:self];
    self.isDetailOpen = !self.isDetailOpen;
    [sender setImage:[UIImage imageNamed:_isDetailOpen ? @"room_style_desc_selected.png" : @"room_style_desc.png"] forState:UIControlStateNormal];
}

- (void)showImage:(id)sender
{
    NSLog(@"show image");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
