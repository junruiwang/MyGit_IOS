//
//  MemberScoreLevelInfo.h
//  JinJiangTravelPlus
//
//  Created by Rong Hao on 13-6-26.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberScoreLevelInfo : NSObject

@property (nonatomic, strong) NSString *scoreLevel;
@property (nonatomic, strong) NSString *updateScore;
@property (nonatomic, strong) NSString *updateTimeSize;
@property (nonatomic, strong) NSString *scoreSlash;

- (id)initWithEmpty;
@end
