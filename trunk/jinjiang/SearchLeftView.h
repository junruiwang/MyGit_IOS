//
//  SearchTVC.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-15.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ControlLeftView.h"

@class SearchVC;

@protocol SearchLeftViewDelegate;

@interface SearchLeftView : ControlLeftView<UITextFieldDelegate,UIPopoverControllerDelegate,UITableViewDelegate,UITableViewDataSource> {
    id <SearchLeftViewDelegate> delegate;
    UITextField *cityTxt;
    UITextField *keywordTxt;
    UITextField *typeTxt;
    
    UITextField *editTxt;
    
    UIPopoverController *popover;
    UITableView *popTableView;
    
    NSMutableArray *citys;
    NSMutableArray *types;
    
    NSInteger selectCity;
     NSInteger selectType;
    
    NSMutableArray *cutData;
    
    SearchVC *searchVC;
    
}
@property (nonatomic, assign) id <SearchLeftViewDelegate> delegate;

- (id)initSearch:(SearchVC *)svc;
-(void)setListData:(NSArray *)data;
@end

@protocol SearchLeftViewDelegate
   -(void)selectView:(NSInteger)index;
@end