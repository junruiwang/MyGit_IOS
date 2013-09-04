//
//  SupportedBankListViewController.h
//  JinJiangTravelPlus
//
//  Created by huguiqi on 13-1-3.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupportedBankListViewController : UIViewController <UITableViewDataSource,UITabBarControllerDelegate>

@property (nonatomic, retain) NSMutableArray *debitCardList;
@property (nonatomic, retain) NSMutableArray *creditCardList;

@property (nonatomic, weak) IBOutlet UITableView *bankListTableView;

@end
