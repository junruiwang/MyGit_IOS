//
//  ParameterManager.m
//  JinJiangTravelPlus
//
//  Created by 汪君瑞 on 12-12-1.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "ParameterManager.h"

@interface ParameterManager ()

@property(nonatomic, strong) NSMutableDictionary *mdict;

@end

@implementation ParameterManager

- (id)init
{
    if(self = [super init])
    {   _mdict = [[NSMutableDictionary alloc] initWithCapacity:30]; }

    return self;
}

- (void) parserStringWithKey:(NSString *) key WithValue:(NSString *) value
{
    if (value && ![value isEqualToString:@""])
    {   [self.mdict setObject:value forKey:key];    }
}

- (void) parserFloatWithKey:(NSString *) key WithValue:(float) value
{
    [self.mdict setObject:[NSString stringWithFormat:@"%f",value] forKey:key];
}

- (void) parserIntegerWithKey:(NSString *) key WithValue:(NSInteger) value
{
    [self.mdict setObject:[NSString stringWithFormat:@"%d",value] forKey:key];
}

- (NSString *)serialization
{
    NSString *requestString = @"";
    NSArray *keys = [self.mdict allKeys];
    for (unsigned int i=0; i<keys.count; i++)
    {
        id key = keys[i];
        id value = [self.mdict objectForKey:key];
        if (value && ![value isEqualToString:@""])
        {
            if (i==0)
            {   requestString = [requestString stringByAppendingFormat:@"%@=%@", key, value];   }
            else
            {   requestString = [requestString stringByAppendingFormat:@"&%@=%@", key, value];  }
        }
    }
    return requestString;
}

@end
