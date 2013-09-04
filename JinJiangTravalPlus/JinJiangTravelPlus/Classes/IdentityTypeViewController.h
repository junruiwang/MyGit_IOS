//
//  IdentityTypeViewController.h
//  JinJiangTravelPlus
//
//  Created by jerry on 13-1-6.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IdentityType.h"

#pragma mark - IdentityTypeViewControllerDelegate

@protocol IdentityTypeViewControllerDelegate <NSObject>

@optional

- (void) pickIdentityDone:(IdentityType *) identityType;

@end

#pragma mark - IdentityTypeViewController

@interface IdentityTypeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) id<IdentityTypeViewControllerDelegate> delegate;

@end
