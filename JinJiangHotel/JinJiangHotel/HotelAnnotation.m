//
//  HotelAnnotation.m
//  storyboardTest
//
//  Created by 胡 桂祁 on 8/26/13.
//  Copyright (c) 2013 huguiqi. All rights reserved.
//

#import "HotelAnnotation.h"

@implementation HotelAnnotation

- (CLLocationCoordinate2D)coordinate;
{
    return self.hotel.coordinate;
}


- (NSString *)title
{
    return self.hotel.name;
}

// optional
- (NSString *)subtitle
{
    return self.hotel.address;
}


@end
