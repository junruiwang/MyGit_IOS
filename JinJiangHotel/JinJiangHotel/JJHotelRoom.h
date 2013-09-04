//
//  JJHotelRoom.h
//  JinJiangTravelPlus
//
//  Created by Leon on 11/19/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomInfoContainer.h"

@interface JJHotelRoom : NSObject

@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageurl;
@property (nonatomic, copy) NSString *roomDesc;
@property (nonatomic, copy) NSString *service;
@property (nonatomic, strong) RoomInfoContainer *infoContainer;

@property (nonatomic, strong) NSMutableArray *planList;

- (NSInteger) generateOnlyTagByRoomId;

@end
