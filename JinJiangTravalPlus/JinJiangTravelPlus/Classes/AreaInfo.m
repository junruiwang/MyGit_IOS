//
//  AreaInfo.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 11/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AreaInfo.h"
#import "FileManager.h"
#import "AreaListParser.h"

@implementation AreaInfo

- (id)initWithName:(NSString *)name1
{
    if (self = [super init])
    {
        self.name = name1;
    }

    return self;
}

@end
