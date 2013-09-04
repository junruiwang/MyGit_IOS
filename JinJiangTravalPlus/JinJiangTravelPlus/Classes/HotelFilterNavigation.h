//
//  HotelFilterNavigation.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 11/24/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelFilterNavigation : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *name;

- (id)initWithNameAndCode:(NSString *)name code:(NSString *) code;

@end
