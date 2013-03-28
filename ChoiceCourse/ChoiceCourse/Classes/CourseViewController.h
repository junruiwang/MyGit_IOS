//
//  CourseViewController.h
//  ChoiceCourse
//
//  Created by 汪君瑞 on 12-10-25.
//  Copyright (c) 2012年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventKit/EventKit.h"
#import "CourseParser.h"
#import "DrawLineView.h"
#import "BannerViewController.h"

@interface CourseViewController : BannerViewController<BaseParserDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UILabel *loginInfo;
@property(nonatomic, strong) CourseParser *courseParser;
@property(nonatomic, strong) IBOutlet UITableView *tableview;
@property(nonatomic, strong) IBOutlet UILabel *teacherTitle;
@property(nonatomic, strong) IBOutlet UIScrollView *detailView;
@property(nonatomic, strong) IBOutlet UILabel *detailTextLabel;
@property(nonatomic, strong) IBOutlet UIImageView *detailImageView;
@property(nonatomic, strong)  NSArray *courseList;


@end
