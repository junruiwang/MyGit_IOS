//
//  ActivationTypeController.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-20.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionView.h"

#pragma mark - ActivationTypeDelegate

@protocol ActivationTypeDelegate <NSObject>

@required

-(void)selectActivationType:(unsigned int) activationTypeIndex;

@end

#pragma mark - ActivationTypeController

@interface ActivationTypeController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak)id<ActivationTypeDelegate> delegate;
@property(nonatomic, strong)NSMutableArray* typeArray;
@property(nonatomic, strong)UITableView* typeTableView;

@end
