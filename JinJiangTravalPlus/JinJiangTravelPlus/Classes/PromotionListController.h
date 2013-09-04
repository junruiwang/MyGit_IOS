//
//  PromotionListController.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 13-1-6.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromotionsParser.h"
#import "HotelOverviewParser.h"
#import "Constants.h"

@interface PromotionListController : JJViewController<UIScrollViewDelegate, UIActionSheetDelegate>
{
    int _hotelId, _index;
    BOOL _pageControlUsed;
    UITapGestureRecognizer* gotoWeb;
}

@property(nonatomic, strong)PromotionsParser* promotionsParser;
@property(nonatomic, strong)HotelOverviewParser* hotelOverviewParser;
@property(nonatomic, strong)NSMutableArray* promotionViewArray;
@property(nonatomic, strong)NSMutableArray* promotionArray;
@property (weak, nonatomic) IBOutlet UIScrollView *bigScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
