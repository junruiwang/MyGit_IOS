//
//  CpaManager.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 4/1/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CpaManagerParser.h"

@interface CpaManager : NSObject <GDataXMLParserDelegate>

- (void) saveMacAddress:(NSString *)deviceToken;

@property (nonatomic, strong) CpaManagerParser *cpaManagerParser;

@end
