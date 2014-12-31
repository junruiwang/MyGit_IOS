//
//  SceneListViewController.h
//  HomeFurnishing
//
//  Created by jerry on 14/12/25.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SceneListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak) IBOutlet UITableView *listTableView;
@property(nonatomic, strong) NSMutableArray *selectedSceneList;

- (void)loadRemoteSceneList;

@end
