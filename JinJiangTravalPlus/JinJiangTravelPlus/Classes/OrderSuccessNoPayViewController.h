//
//  OrderResultViewController.h
//  JinJiangTravelPlus
//
//  Created by huguiqi on 12-12-18.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelBookForm.h"
#import "OrderPassbookViewController.h"

@interface OrderSuccessNoPayViewController : JJViewController

@property(nonatomic, strong) HotelBookForm *bookForm;
@property(nonatomic, weak) IBOutlet UIView *bgView;
@property(nonatomic, weak) IBOutlet UILabel *fullNameLabel;
@property(nonatomic, weak) IBOutlet UILabel *hotelNameLabel;
@property(nonatomic, weak) IBOutlet UILabel *roomNameLabel;
@property(nonatomic, weak) IBOutlet UILabel *roomCountLabel;
@property(nonatomic, weak) IBOutlet UILabel *roomPerLabel;
@property(nonatomic, weak) IBOutlet UILabel *checkInDateLabel;
@property(nonatomic, weak) IBOutlet UILabel *checkOutDateLabel;
@property(nonatomic, weak) IBOutlet UILabel *nightsNumLabel;
@property(nonatomic, weak) IBOutlet UILabel *contactMobileLabel;
@property(nonatomic, weak) IBOutlet UILabel *totalAmountLabel;
@property(nonatomic, weak) IBOutlet UIImageView *splitLine1;
@property(nonatomic, weak) IBOutlet UIImageView *splitLine2;

@property(nonatomic,weak) IBOutlet UIButton *passbookBtn;
@property(nonatomic, copy) NSString *hotelBrand;
@property(nonatomic,copy) NSString *latitude;
@property(nonatomic,copy) NSString *longitude;
@property(nonatomic,copy) NSString *hotelAddress;
@property(nonatomic,strong) UIButton *backToHomeBtn;

@property(nonatomic,strong) OrderPassbookViewController *showPassbookController;

-(IBAction)clickAddToPassbook:(id)sender;

@end
