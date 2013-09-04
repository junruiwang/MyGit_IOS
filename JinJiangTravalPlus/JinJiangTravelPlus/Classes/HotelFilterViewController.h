//
//  HotelFilterViewController.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 11/24/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTableDelegate.h"
#import "ConditionView.h"
#import "ConditionTableDelegate.h"
#import "GAITrackedViewController.h"

@class ConditionTableDelegate;

@protocol HotelFilterViewDelegate
    -(void)closeHotelFilterView;
    -(void)clearFilterValue;
@end

@interface HotelFilterViewController : GAITrackedViewController <HandleSelectedNavigationDelegate,ConditionTableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *navigateTable;

@property (weak, nonatomic) IBOutlet UITableView *conditionTable;

@property (weak, nonatomic) IBOutlet UIView *conditionTableView;

@property (weak, nonatomic) IBOutlet UIView *navigateTableView;

@property (nonatomic, strong) ConditionView *conditionView;

@property (nonatomic, strong) NavigateTableDelegate *navigateTableDelegate;

@property (nonatomic, strong) ConditionTableDelegate *conditionTableDelegate;

@property (weak, nonatomic) id<HotelFilterViewDelegate>  hotelFilterViewDelegate;

@end
