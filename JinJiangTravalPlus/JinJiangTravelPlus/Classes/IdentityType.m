//
//  IdentityType.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-1-6.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "IdentityType.h"

@implementation IdentityType

- (id)initWithName:(NSString *) typeName cnName:(NSString *)typeCnName
{
    if (typeName == nil || typeCnName == nil)
    {
        self = [super init];
        return self;
    }

    if (self = [super init])
    {
        self.identityTypeName = typeName;
        self.identityTypeCnName = typeCnName;
    }
    return self;
}

@end
