//
//  MemberScoreLevelInfo.m
//  JinJiangTravelPlus
//
//  Created by Rong Hao on 13-6-26.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "MemberScoreLevelInfo.h"

@implementation MemberScoreLevelInfo

- (id)initWithEmpty
{
    if (self = [super init]) {
        self.scoreLevel = @"4";
        self.updateScore = @"";
        self.updateTimeSize = @"";
        self.scoreSlash = @"";
    }
    return self;
}

@end
