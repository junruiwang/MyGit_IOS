//
//  UserInfo.h
//  JinJiangTravalPlus
//
//  Created by 汪君瑞 on 12-11-9.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberScoreLevelInfo.h"

@interface UserInfo : NSObject<NSCoding, NSCopying>

//JJCARD("JJ Card", "礼卡", 1),
//JBENEFITCARD("J Benefit Card", "享卡", 2),
//J2BENEFITCARD("J2 Benefit Card", "悦享卡", 3),
//J8BENEFITCARD("J8 Benefit Card", "无限享卡", 4);

@property (nonatomic, copy) NSString* uid;
@property (nonatomic, copy) NSString* cardNo;
@property (nonatomic, copy) NSString* loginName;
@property (nonatomic, copy) NSString* fullName;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* point;
@property (nonatomic, copy) NSString* address;
@property (nonatomic, copy) NSString* mobile;
@property (nonatomic, copy) NSString* cardLevel;
@property (nonatomic, copy) NSString* cardType;
@property (nonatomic, copy) NSString* dueDate;
@property (nonatomic, copy) NSString* isTempMember;
@property (nonatomic, copy) NSString* flag;
@property (nonatomic, copy) NSString* identityNo;
@property (nonatomic, copy) NSString* identityType;
@property (nonatomic, copy) NSString* rankScore;
@property (nonatomic, copy) NSString* rankTimeSize;
@property (nonatomic, copy) NSString* splashChar;
@property (nonatomic, copy) NSString *rankLevelScore;
@property (nonatomic, copy) NSString *rankLevelTimeSize;

@property (nonatomic) BOOL isForGuestOrder;

+ (UserInfo *)unarchived:(NSData *) data;

- (BOOL)checkIsLogin;
- (NSData *)archived;
- (void)getMemberScoreLevelByCardLevel:(NSArray *)memberScoreLevelInfos;

@end
