//
//  AreaInfo.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 11/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AreaListParser.h"

@interface AreaInfo : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* code;

- (id)initWithName:(NSString *)name;

@end
