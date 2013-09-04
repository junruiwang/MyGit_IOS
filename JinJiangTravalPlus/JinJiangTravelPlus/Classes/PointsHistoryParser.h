//
//  PointsHistoryParser.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 7/17/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "GDataXMLParser.h"
#import "GDataXMLNode.h"

#define kKeyCode  @"code"
#define kKeyMessage  @"message"
#define kKeyUsablePoints @"usablePoints"
#define kKeyValidDate @"validDate"
#define kKeyUsedPoints @"usedPoints"
#define kKeyMonth @"yearMonth"
#define kKeyAddPoints @"addPoints"


@interface PointsHistoryParser : GDataXMLParser

-(void)loadHistoryPointsRecentMonth;

@end
