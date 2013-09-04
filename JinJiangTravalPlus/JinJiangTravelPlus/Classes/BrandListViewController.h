//
//  BrandListViewController.h
//  JinJiangTravalPlus
//
//  Created by jerry on 12-11-5.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brand.h"

@class BrandListViewController;

@protocol BrandListViewControllerDelegate <NSObject>

@optional
- (void) pickBrandDone:(Brand *) brand;

@end


@interface BrandListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UITableView *brandTableView;
@property(nonatomic, assign) id<BrandListViewControllerDelegate> delegate;

@end
