//
//  ParameterManager.h
//  JinJiangTravelPlus
//
//  Created by 汪君瑞 on 12-12-1.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParameterManager : NSObject

- (void) parserStringWithKey:(NSString *) key WithValue:(NSString *) value;
- (void) parserFloatWithKey:(NSString *) key WithValue:(float) value;
- (void) parserIntegerWithKey:(NSString *) key WithValue:(NSInteger) value;
- (NSString *)serialization;

@end
