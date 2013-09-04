//
//  Promotion.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 13-1-5.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PromotionAddress @"地址链接:"
#define PromotionPhoto @"IMAGE"
#define PromotionHotel @"HOTEL"
#define PromotionRegister @"REGISTER"
#define PromotionActivate @"ACTIVATE"
#define PromotionHotelSearch @"HOTEL_SEARCH"
#define PromotionJINNSearch @"JJIN_SEARCH"

typedef enum
{
    PromotionCategoryUnknown = 720,
    PromotionCategoryWeblink,
    PromotionCategoryPicture,
    PromotionCategoryHotel,
    PromotionCategoryRegister,
    PromotionCategoryActivate,
    PromotionCategoryHotelSearch,
    PromotionCategoryJINNSearch,
    PromotionCategoryTravel,
}   PromotionCategory;

@interface Promotion : NSObject
{
    int actionId;
    int promotionId;
    BOOL isEnd;
    BOOL isRead;
    BOOL isAction;
    NSString* type;
    NSString* bannerLink;
    NSString* title;
    NSString* body;
    NSString* webLink;
    NSString* dateFrom;
    NSString* dateTo;
}

@property (nonatomic) int promotionId;
@property (nonatomic) int actionId;
@property (nonatomic) BOOL isEnd;
@property (nonatomic) BOOL isRead;
@property (nonatomic) BOOL isAction;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* bannerLink;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* body;
@property (nonatomic, strong) NSString* webLink;
@property (nonatomic, strong) NSString* dateFrom;
@property (nonatomic, strong) NSString* dateTo;
@property (nonatomic) PromotionCategory category;
@property (nonatomic) int productId;
@property (nonatomic, strong) NSString* shareDesc;
@property (nonatomic, strong) NSString* smallBannerLink;
@property (nonatomic, strong) NSString* largeBannerLink;

@end
