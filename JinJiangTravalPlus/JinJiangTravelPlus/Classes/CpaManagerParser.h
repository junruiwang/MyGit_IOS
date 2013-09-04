//
//  CpaManagerParser.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 4/1/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "GDataXMLParser.h"

@interface CpaManagerParser : GDataXMLParser

-(void)saveActiveMacAddress:(NSString *) macAddress deviceToken:(NSString *)deviceToken;

@end
