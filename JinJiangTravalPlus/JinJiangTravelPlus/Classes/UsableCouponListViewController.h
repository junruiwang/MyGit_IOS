//
//  UsableCouponListViewController.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 1/9/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UseCoupon.h"

@protocol SelectUsableCouponDelegate <NSObject>

-(void)buildUseCoupon:(UseCoupon *) useCoupon;

@end

@interface UsableCouponListViewController : JJViewController<UITableViewDelegate,  UITableViewDataSource>

@property (nonatomic,strong) NSArray *couponList;
@property (nonatomic,strong) NSArray *couponUseObjList;

@property (nonatomic,strong) UseCoupon *useCoupon;
@property (nonatomic,weak) id<SelectUsableCouponDelegate> delegate;

@property (nonatomic,strong) IBOutlet UITableView *couponListTableView;

@end
