//
//  AreaListViewController.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 11/20/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaListHandle.h"
#import "LoadingIndicatorViewController.h"

@class AreaListParser;
@class AreaListHandle;

@protocol AreaListViewDelegate

    -(void)selectArea:(NSString *) areaName;

@end

@interface AreaListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,
                                                      GDataXMLParserDelegate, AreaListHandleDelegate>

@property (nonatomic, weak) id<AreaListViewDelegate> areaListDelegate;
@property (nonatomic, strong) AreaListParser *areaListParser;
@property (nonatomic, strong) IBOutlet UITableView *areaListTableView;
@property (nonatomic, strong) AreaListHandle *areaListHandle;

@property (nonatomic, strong) NSMutableArray *areas;

- (void)downloadData;

@end
