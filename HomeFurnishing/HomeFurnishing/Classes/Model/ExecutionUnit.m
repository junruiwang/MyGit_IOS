//
//  ExecutionUnit.m
//  HomeFurnishing
//
//  Created by jerry on 14/12/23.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import "ExecutionUnit.h"
#import "ValidateInputUtil.h"

@implementation ExecutionUnit

+ (ExecutionUnit *)unarchived:(NSData *) data
{
    ExecutionUnit *execUnit = (ExecutionUnit *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return execUnit;
}

- (id) initWithDictionary : (NSDictionary *) dict
{
    if (dict == nil) {
        self = [super init];
        return self;
    }
    
    if (self = [super init]) {
        self.executCode = [ValidateInputUtil valueOfObjectToString:[dict objectForKey:@"executCode"]];
        self.imageName = [ValidateInputUtil valueOfObjectToString:[dict objectForKey:@"imageName"]];
        self.cName = [ValidateInputUtil valueOfObjectToString:[dict objectForKey:@"cName"]];
        self.eName = [ValidateInputUtil valueOfObjectToString:[dict objectForKey:@"eName"]];
        self.displayNumber = (NSInteger)[dict objectForKey:@"displayNumber"];
        self.sceneArray = [dict objectForKey:@"sceneArray"];
    }
    return self;
}

- (NSData *)archived
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.executCode = [aDecoder decodeObjectForKey:@"executCode"];
        self.imageName = [aDecoder decodeObjectForKey:@"imageName"];
        self.cName = [aDecoder decodeObjectForKey:@"cName"];
        self.eName = [aDecoder decodeObjectForKey:@"eName"];
        self.displayNumber = [aDecoder decodeIntegerForKey:@"displayNumber"];
        self.sceneArray = [aDecoder decodeObjectForKey:@"sceneArray"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.executCode forKey:@"executCode"];
    [aCoder encodeObject:self.imageName forKey:@"imageName"];
    [aCoder encodeObject:self.cName forKey:@"cName"];
    [aCoder encodeObject:self.eName forKey:@"eName"];
    [aCoder encodeInteger:self.displayNumber forKey:@"displayNumber"];
    [aCoder encodeObject:self.sceneArray forKey:@"sceneArray"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    ExecutionUnit *execUnit = [[self class] allocWithZone:zone];
    self.executCode = [self.executCode copyWithZone:zone];
    self.imageName = [self.imageName copyWithZone:zone];
    self.cName = [self.cName copyWithZone:zone];
    self.eName = [self.eName copyWithZone:zone];
    self.sceneArray = [self.sceneArray copyWithZone:zone];
    return execUnit;
}


- (NSString *)getIdsByAll
{
    NSMutableString *ids = [NSMutableString stringWithString:@""];
    for (NSInteger i=0; i<self.sceneArray.count; i++) {
        NSMutableDictionary *dict = self.sceneArray[i];
        if (i == 0) {
            [ids appendString:[dict objectForKey:@"id"]];
        } else {
            [ids appendString:@","];
            [ids appendString:[dict objectForKey:@"id"]];
        }
    }
    
    return [ids copy];
}

@end
