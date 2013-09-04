//
//  StarLevel.m
//  JinJiangTravelPlus
//
//  Created by huguiqi on 11/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StarLevel.h"

@implementation StarLevel

- (id)initWithCode:(NSString *)code textShow:(NSString *)textShow
{
    self = [super init];
    if (self) {
        _code = code;
        _textShow = textShow;
        _isSelected = NO;
    }
    return self;
}

+ (NSArray *)getStarLevelList {
    StarLevel *noStar = [[StarLevel alloc] initWithCode:nil textShow:@"不限"];
    StarLevel *business = [[StarLevel alloc] initWithCode:@"ONE,TWO" textShow:@"经济型酒店"];
    StarLevel *threeStar = [[StarLevel alloc] initWithCode:@"THREE" textShow:@"3星级"];
    StarLevel *fourStar = [[StarLevel alloc] initWithCode:@"FOUR" textShow:@"4星级"];
    StarLevel *fiveStar = [[StarLevel alloc] initWithCode:@"FIVE" textShow:@"5星级"];
    return [NSArray arrayWithObjects:noStar,business,threeStar,fourStar,fiveStar, nil];
}

- (BOOL) isDefault
{
    return self.code == nil;
}


@end
