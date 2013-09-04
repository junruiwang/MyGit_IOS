//
//  City.m
//  JinJiang
//
//  Created by 金友 杨 on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AllCity.h"

@implementation AllCity

@synthesize key;

@synthesize name;

@synthesize provinceName;

- (id) initWithDictionary : (NSDictionary *) dict
{
    if (dict == nil) {
        self = [super init];
        return self;
    }
    
    if (self = [super init]) {
        self.key = [dict objectForKey:@"key"];
        self.name = [dict objectForKey:@"name"];
        self.provinceName = [dict objectForKey:@"provinceName"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder 
{
    self = [super init];

    self.key = [coder decodeObjectForKey:@"key"];
    self.name = [coder decodeObjectForKey:@"name"];
    self.provinceName = [coder decodeObjectForKey:@"provinceName"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder 
{
    [coder encodeObject:self.key forKey:@"key"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.provinceName forKey:@"provinceName"];
}

@end
