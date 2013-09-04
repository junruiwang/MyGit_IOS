//
//  PayTypeListViewController.h
//  JinJiangHotel
//
//  Created by jerry on 13-8-27.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayType.h"

@protocol PayTypeListDelegate <NSObject>

@optional
- (void) selectedPayType : (PayType *) payType;
@end

@interface PayTypeListViewController : UIViewController

@property (nonatomic, weak) id<PayTypeListDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *payTypeList;
@property (nonatomic, strong) PayType *selectedPayType;

@property (nonatomic, weak) IBOutlet UIView *payTypeView;

- (IBAction)selectedButtonClicked:(id)sender;

@end
