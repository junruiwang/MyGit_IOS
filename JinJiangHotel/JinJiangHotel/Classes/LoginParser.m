//
//  LoginParser.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-15.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "LoginParser.h"
#import "GDataXMLNode.h"
#import "UserInfo.h"
#import "MemberScoreLevelInfo.h"

@implementation LoginParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString] )
    {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];

        UserInfo *userInfo = [[UserInfo alloc] init];
        userInfo.uid = [[rootElement firstElementForName:@"userId"] stringValue];
        userInfo.cardNo = [[rootElement firstElementForName:@"cardNo"] stringValue];
        userInfo.cardLevel = [[rootElement firstElementForName:@"cardLevel"] stringValue];
        userInfo.cardType = [[rootElement firstElementForName:@"cardType"] stringValue];
        userInfo.dueDate = [[rootElement firstElementForName:@"dueDate"] stringValue];
        userInfo.mobile = [[rootElement firstElementForName:@"mobile"] stringValue];
        userInfo.email = [[rootElement firstElementForName:@"email"] stringValue];
        userInfo.point = [[rootElement firstElementForName:@"point"] stringValue];
        userInfo.identityNo = [[rootElement firstElementForName:@"identityNo"] stringValue];
        userInfo.identityType = [[rootElement firstElementForName:@"identityType"] stringValue];
        if ([userInfo.point isEqualToString:@"null"])
        {   userInfo.point = nil;   }
        userInfo.address = [[rootElement firstElementForName:@"address"] stringValue];
        userInfo.fullName = [[rootElement firstElementForName:@"fullName"] stringValue];
        userInfo.isTempMember = [[rootElement firstElementForName:@"flag"] stringValue];
        //当前定级积分与定级间夜数
        userInfo.rankScore = [[rootElement firstElementForName:@"rankScore"] stringValue];
        userInfo.rankTimeSize = [[rootElement firstElementForName:@"rankTimeSize"] stringValue];
        
        //解析礼卡各级别定级指标
        NSArray *scoreLevelInfos = [[rootElement firstElementForName:@"MemberScoreLevelInfos"] elementsForName:@"MemberScoreLevelInfo"];
        NSMutableArray *memberScoreLevels = [NSMutableArray array];
        for (GDataXMLElement *memberScoreLevel in scoreLevelInfos) {
            MemberScoreLevelInfo *msli = [[MemberScoreLevelInfo alloc] init];
            msli.scoreLevel = [[memberScoreLevel firstElementForName:@"scoreLevel"] stringValue];
            msli.updateScore = [[memberScoreLevel firstElementForName:@"updateScore"] stringValue];
            msli.updateTimeSize = [[memberScoreLevel firstElementForName:@"updateTimeSize"] stringValue];
            [memberScoreLevels addObject:msli];
        }
        [userInfo getMemberScoreLevelByCardLevel:memberScoreLevels];
        
        NSDictionary *data = @{@"userInfo":userInfo};
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {   [self.delegate parser:self DidParsedData:data]; }
    }
    return YES;
}

@end
