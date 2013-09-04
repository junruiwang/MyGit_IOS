//
//  UserInfo.m
//  JinJiangTravalPlus
//
//  Created by 汪君瑞 on 12-11-9.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (UserInfo *)unarchived:(NSData *) data
{
    return (UserInfo *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (id)init
{
    if (self = [super init])
    {
        _uid = @"0";
        _flag = @"false";
    }
    return self;
}

- (BOOL)checkIsLogin
{
    if (self.cardNo && self.loginName && [self.flag caseInsensitiveCompare:@"true"] == NSOrderedSame)
    {
        return YES;
    }
    return NO;
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
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.cardNo = [aDecoder decodeObjectForKey:@"cardNo"];
        self.loginName = [aDecoder decodeObjectForKey:@"loginName"];
        self.fullName = [aDecoder decodeObjectForKey:@"fullName"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.point = [aDecoder decodeObjectForKey:@"point"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.cardType = [aDecoder decodeObjectForKey:@"cardType"];
        self.cardLevel = [aDecoder decodeObjectForKey:@"cardLevel"];
        self.dueDate = [aDecoder decodeObjectForKey:@"dueDate"];
        self.isTempMember = [aDecoder decodeObjectForKey:@"isTempMember"];
        self.flag = [aDecoder decodeObjectForKey:@"flag"];
        self.rankLevelTimeSize = [aDecoder decodeObjectForKey:@"rankLevelTimeSize"];
        self.rankLevelScore = [aDecoder decodeObjectForKey:@"rankLevelScore"];
        self.rankScore = [aDecoder decodeObjectForKey:@"rankScore"];
        self.rankTimeSize = [aDecoder decodeObjectForKey:@"rankTimeSize"];
        self.splashChar = [aDecoder decodeObjectForKey:@"splashChar"];
    }

    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.cardNo forKey:@"cardNo"];
    [aCoder encodeObject:self.loginName forKey:@"loginName"];
    [aCoder encodeObject:self.fullName forKey:@"fullName"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.point forKey:@"point"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.cardType forKey:@"cardType"];
    [aCoder encodeObject:self.cardLevel forKey:@"cardLevel"];
    [aCoder encodeObject:self.dueDate forKey:@"dueDate"];
    [aCoder encodeObject:self.isTempMember forKey:@"isTempMember"];
    [aCoder encodeObject:self.flag forKey:@"flag"];
    [aCoder encodeObject:self.rankTimeSize forKey:@"rankTimeSize"];
    [aCoder encodeObject:self.rankScore forKey:@"rankScore"];
    [aCoder encodeObject:self.rankLevelScore forKey:@"rankLevelScore"];
    [aCoder encodeObject:self.rankLevelTimeSize forKey:@"rankLevelTimeSize"];
    [aCoder encodeObject:self.splashChar forKey:@"splashChar"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    UserInfo* userInfo = [[self class] allocWithZone:zone];
    self.uid = [self.uid copy];
    self.cardNo = [self.cardNo copy];
    self.loginName = [self.loginName copy];
    self.fullName = [self.fullName copy];
    self.email = [self.email copy];
    self.point = [self.point copy];
    self.address = [self.address copy];
    self.mobile = [self.mobile copy];
    self.cardType = [self.cardType copy];
    self.cardLevel = [self.cardLevel copy];
    self.dueDate = [self.dueDate copy];
    self.isTempMember = [self.isTempMember copy];
    self.flag = [self.flag copy];
    self.rankLevelTimeSize = [self.rankLevelTimeSize copy];
    self.rankLevelScore = [self.rankLevelScore copy];
    self.rankScore = [self.rankScore copy];
    self.rankTimeSize = [self.rankTimeSize copy];
    self.splashChar = [self.splashChar copy];
    return userInfo;
}

- (void)getMemberScoreLevelByCardLevel:(NSArray *)memberScoreLevelInfos
{
    for (MemberScoreLevelInfo *msli in memberScoreLevelInfos) {
        if ([@"true" isEqualToString:self.isTempMember] || msli == nil) return;
        if (self.cardLevel != nil && [self.cardLevel isEqualToString:msli.scoreLevel]) {
            self.splashChar = @"/";
            self.rankLevelTimeSize = msli.updateTimeSize;
            self.rankLevelScore = msli.updateScore;
            return;
        }
    }
    self.splashChar = @"";
    self.rankLevelScore = @"";
    self.rankLevelTimeSize = @"";
}
@end
