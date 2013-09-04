//
//  PromotionView.m
//  JinJiangTravelPlus
//
//  Created by Raphael.rong on 13-3-18.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "PromotionView.h"

@interface PromotionView()


@end

@implementation PromotionView

const float tr = 48.00f / 255.0f;
const float tg = 84.00f / 255.0f;
const float tb = 120.0f / 255.0f;
const float ggg = 60.0f / 255.0f;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        UIImageView *topBackgroundImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"营销中心_adbg.png"]];
        UIImageView *middleBackGroundImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"营销中心_bg.png"]];
        UIImageView *bottomBackgrounImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"营销中心_foot.png"]];
        
        topBackgroundImg.frame = CGRectMake(0, 0, 320, 240);
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5] == YES){
            middleBackGroundImg.frame = CGRectMake(0, 240, 320, 229);
            bottomBackgrounImg.frame = CGRectMake(0, 469, 320, 35);
            
        } else {
            middleBackGroundImg.frame = CGRectMake(0, 240, 320, 141);
            bottomBackgrounImg.frame = CGRectMake(0, 381, 320, 35);
        }
        
        
        [self addSubview:topBackgroundImg];
        [self addSubview:middleBackGroundImg];
        [self addSubview:bottomBackgrounImg];
        
    }
    return self;
}


-(void)addTextInfo:(Promotion *)promotion
{
    CGFloat textViewHeight = [[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5] ? 100 + 88 : 100;
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(20, 240, 260, 32)];
    [title setTextAlignment:NSTextAlignmentLeft];[title setText:promotion.title];
    [title setFont:[UIFont boldSystemFontOfSize:14]];
    [title setNumberOfLines:2];
    [title setTextColor:[UIColor colorWithRed:tr green:tg blue:tb alpha:1]];
    [title setBackgroundColor:[UIColor clearColor]];
    [self addSubview:title];
    
    UITextView* body = [[UITextView alloc] initWithFrame:CGRectMake(15, 265, 290, textViewHeight)];
    [body setText:promotion.body];[body setBackgroundColor:[UIColor clearColor]];
    [body setTextColor:[UIColor colorWithRed:ggg green:ggg blue:ggg alpha:1]];
    [body setScrollEnabled:YES];[body setFont:[UIFont systemFontOfSize:12]];
    [body setDataDetectorTypes:UIDataDetectorTypeNone];
    [body setEditable:NO];
    [self addSubview:body];
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
