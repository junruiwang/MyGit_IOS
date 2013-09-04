//
//  RenewCardViewController.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 7/26/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RenewCardParser.h"
#import "RenewOrderPriceParser.h"
#import "AlipayForm.h"
#import "AlipayParser.h"

@interface RenewCardViewController : JJViewController

@property(nonatomic,weak) IBOutlet UILabel *descLabel1;
@property(nonatomic,weak) IBOutlet UILabel *descLabel3;
@property(nonatomic,weak) IBOutlet UIButton *buyBtn;
@property(nonatomic,weak) IBOutlet UILabel *fullNameLabel;
@property(nonatomic,weak) IBOutlet UILabel *cardNoLabel;
@property(nonatomic,weak) IBOutlet UIImageView *reNewcardBgImg;

@property(nonatomic,strong) RenewCardParser *renewCardParser;
@property(nonatomic,strong) RenewOrderPriceParser *renewOrderPriceParser;
@property(nonatomic,strong) AlipayParser *alipayParser;

@property(nonatomic,copy) NSString *orderNo;
@property(nonatomic,copy) NSString *bgUrl;
@property(nonatomic,copy) NSString *amount;

@property(nonatomic,strong) AlipayForm *alipayForm;


-(IBAction)createOrderForBuy:(id)sender;


@end
