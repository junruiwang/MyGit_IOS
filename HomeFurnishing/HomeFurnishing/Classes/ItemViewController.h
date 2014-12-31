//
//  ItemViewController.h
//  HomeFurnishing
//
//  Created by jrwang on 14-12-13.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MyLauncherItem.h"
#import "ExecutionUnit.h"

@class ItemViewController;

@protocol ItemViewControllerDelegate <NSObject>

@optional

- (void)backButtonClicked;
- (void)saveItemButtonClicked:(MyLauncherItem *)item;
- (void)delItemButtonClicked:(MyLauncherItem *)item;

@end

@interface ItemViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property(nonatomic, weak) IBOutlet UIButton *imageBtn;
@property(nonatomic, weak) IBOutlet UITableView *selSceneTableView;
@property(nonatomic, strong) ExecutionUnit *execUnit;
@property(nonatomic, weak) id<ItemViewControllerDelegate> delegate;

- (IBAction)imageButtonClicked:(id)sender;
- (IBAction)sceneButtonClicked:(id)sender;
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)saveBtnClicked:(id)sender;
- (IBAction)deleteBtnClicked:(id)sender;

@end
