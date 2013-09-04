//
//  DayPriceDetailViewController.h
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 13-1-12.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
#import "DayPriceDetail.h"
#import "OrderPriceConfirm.h"

@protocol DayPriceDetailViewControllerDelegate <NSObject>

- (void) closeDayPriceDetailView;

@end

@interface DayPriceDetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *closeBtn;

@property (nonatomic, weak) IBOutlet UIButton *realCloseBtn;

@property (nonatomic, weak) IBOutlet UIView *line1;

@property (nonatomic, weak) IBOutlet UIScrollView *dayPriceDetailScollView;

@property (nonatomic, weak) IBOutlet UITableView *dayPriceDetailTabel;

@property (nonatomic, weak) IBOutlet UIView *line2;

@property (nonatomic, weak) IBOutlet UILabel *addtionalChargeLabel;

@property (nonatomic, weak) IBOutlet UILabel *couponLabel;

@property (nonatomic, weak) IBOutlet UIView *line3;

@property (nonatomic, weak) IBOutlet UILabel *totalPriceLetterLabel;

@property (nonatomic, weak) IBOutlet UILabel *totalPriceLabel;

@property (nonatomic, weak) IBOutlet UILabel *paymentPriceLabel;

@property (nonatomic, strong) OrderPriceConfirm *orderPriceConfirm;

@property (nonatomic, strong) NSString *payType;

@property (nonatomic, weak) id<DayPriceDetailViewControllerDelegate> delegate;

@property (nonatomic, copy) NSString *couponAmount;

@property (nonatomic) NSUInteger roomCount;

- (IBAction) closeDayPriceDetailView;

@end
