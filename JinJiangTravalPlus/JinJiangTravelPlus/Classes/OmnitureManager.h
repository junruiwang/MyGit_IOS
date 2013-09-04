//
//  OmnitureManager.h
//  JinJiang
//
//  Created by Leon on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppMeasurement.h"

@interface OmnitureManager : NSObject

+ (void)trackWithVariables:(NSDictionary *)vars;
+ (void)trackCustomLinkWithLinkname:(NSString *)linkName variables:(NSDictionary *)vars;

@end
