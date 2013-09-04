//
//  PayTypeListViewController.h
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 12-12-13.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayType.h"

@protocol PayTypeListDelegate <NSObject>

@optional
- (void) selectedPayType : (PayType *) payType;
@end

@interface PayTypeListViewController : UIViewController <UITableViewDelegate,  UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *payTypeListTable;

@property (nonatomic, weak) id<PayTypeListDelegate> delegate;

@property(nonatomic, strong) NSMutableArray *payTypeList;

@end
