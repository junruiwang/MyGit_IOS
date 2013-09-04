//
//  JJHotelRoom.m
//  JinJiangTravelPlus
//
//  Created by Leon on 11/19/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#define kOnlyNumber  10

#import "JJHotelRoom.h"

@implementation JJHotelRoom

- (NSInteger) generateOnlyTagByRoomId
{
    NSString *tag = [NSString stringWithFormat:@"%d",kOnlyNumber];
    [tag stringByAppendingFormat:@"%d",self.roomId];
    
    return tag.intValue;
}

@end
