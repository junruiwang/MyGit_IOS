//
//  ActivateJJInnMemberParser.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-18.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLParser.h"

typedef enum
{
    JJInnActivateResultHasAlreadyActivated = -2,
    JJInnActivateResultFailed = -1,
    JJInnActivateResultNotExist = 0,
    JJInnActivateResultHaveMobile,
    JJInnActivateResultHaveEmail,
    JJInnActivateResultNoMobileAndEmail,
}   JJInnActivateResult;

@interface ActivateJJInnMemberParser : GDataXMLParser

@end
