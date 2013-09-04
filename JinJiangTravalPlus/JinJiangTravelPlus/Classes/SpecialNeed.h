//
//  SpecialNeed.h
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 13-7-16.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialNeed : NSObject

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *name;

- (id) initWithCodeAndName : (NSString *) code name:(NSString *) name;

@end
