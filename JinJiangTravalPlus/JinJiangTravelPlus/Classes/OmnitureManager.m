//
//  OmnitureManager.m
//  JinJiang
//
//  Created by Leon on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OmnitureManager.h"

@implementation OmnitureManager

+ (void)trackWithVariables:(NSDictionary *)vars
{
#ifdef OmnitureEnabled
    AppMeasurement *measurement = [AppMeasurement getInstance];
    [measurement clearVars];
    [measurement track:vars];
#endif
}

+ (void)trackCustomLinkWithLinkname:(NSString *)linkName variables:(NSDictionary *)vars
{
#ifdef OmnitureEnabled
    AppMeasurement *measurement = [AppMeasurement getInstance];
    [measurement clearVars];
    [measurement trackLink:nil linkType:@"o" linkName:linkName variableOverrides:vars];
#endif
}

@end
