//
//  SpecialNeedListViewController.h
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 13-7-16.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SpecialNeedListViewControllerDelegate <NSObject>

- (void) didDeterminSpecialNeeds : (NSString *) specialNeeds;

@end

@interface SpecialNeedListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *specialNeedList;

@property (nonatomic, weak) IBOutlet UITableView *specialNeedListTableView;

@property (nonatomic, copy) NSMutableString *selectedSpecialNeeds;

@property (nonatomic, strong) NSMutableArray *selectedSpecialNeedArray;

@property (nonatomic, strong) id<SpecialNeedListViewControllerDelegate> delegate;

@property (nonatomic) NSInteger roomCount;

- (IBAction) clickOkButton : (id) sender;

@end
