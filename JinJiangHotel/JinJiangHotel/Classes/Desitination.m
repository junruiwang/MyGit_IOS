//
//  Desitination.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-3-6.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "Desitination.h"

static const float kDistanceFilter = 0.002;

@implementation Desitination

- (id)initWithCoords:(CLLocationCoordinate2D)coords
{
	self = [super init];
	if (self != nil)
    {
        _coordinate = coords;
    }
	return self;
}

@end
