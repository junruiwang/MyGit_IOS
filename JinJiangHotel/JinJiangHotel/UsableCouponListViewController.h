//
//  UsableCouponListViewController.h
//  JinJiangHotel
//
//  Created by jerry on 13-8-29.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UseCoupon.h"
#import "CouponRuleView.h"

@protocol SelectUsableCouponDelegate <NSObject>

- (void)buildUseCoupon:(UseCoupon *) useCoupon;

@end


@interface UsableCouponListViewController : UIViewController<CouponRuleViewDelegate>

@property (nonatomic,strong) NSMutableArray *couponList;
@property (nonatomic,strong) UseCoupon *useCoupon;
@property (nonatomic,weak) id<SelectUsableCouponDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIView *couponsView;

- (IBAction)selectedButtonClicked:(id)sender;

@end
