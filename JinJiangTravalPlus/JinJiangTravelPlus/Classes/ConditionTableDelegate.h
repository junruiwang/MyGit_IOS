//
//  ConditionTableDelegate.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 11/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "AreaListHandle.h"

@class HotelFilterNavigation;

@protocol ConditionTableCellDelegate
    -(void)selectedConditionValue:(NSString *) str;
@end

@interface ConditionTableDelegate : NSObject <UITableViewDataSource, UITableViewDelegate, AreaListHandleDelegate>

@property (assign, nonatomic) HotelFilterNavigation *hotelFilterNavigation;
@property(retain,nonatomic) NSMutableDictionary *dic;
@property (nonatomic, strong) AreaListHandle *areaListHandle;
@property (nonatomic, weak) id<ConditionTableCellDelegate> conditionTableCellDelegate;

@end
