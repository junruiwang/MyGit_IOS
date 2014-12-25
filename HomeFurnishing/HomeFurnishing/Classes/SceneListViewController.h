//
//  SceneListViewController.h
//  HomeFurnishing
//
//  Created by jerry on 14/12/25.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) IBOutlet UITableView *listTableView;

@end
