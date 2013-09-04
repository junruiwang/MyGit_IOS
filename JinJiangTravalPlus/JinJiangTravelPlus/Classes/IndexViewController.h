//
//  IndexViewController.h
//  JinJiangTravalPlus
//
//  Created by 杨 栋栋 on 12-10-31.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJViewController.h"
#import "ClientVersionParser.h"
#import "ActiveOrderListParser.h"
@class LoginViewController;
@class BillListController;


@interface IndexViewController :JJViewController <UIActionSheetDelegate, UIScrollViewDelegate, UIAlertViewDelegate, GDataXMLParserDelegate>

@property(nonatomic, strong)ActiveOrderListParser* activeOrderListParser;
@property(nonatomic, strong) ClientVersionParser *clientVersionParser;
@property(nonatomic, weak) IBOutlet UIButton *billButton;
@property(nonatomic, weak) IBOutlet UIView *viewForUserDevice4;
@property(nonatomic, weak) IBOutlet UIView *viewForUserDevice5;
@property(nonatomic, weak) IBOutlet UIView *shakeBgView;
@property(nonatomic, weak) IBOutlet UIButton *shakeMobileButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property(nonatomic, weak) IBOutlet UIButton *activityButton;
@property (weak, nonatomic) IBOutlet UIView *activityButtonView;

- (IBAction)callPhone:(id)sender;
- (IBAction)memberCenter:(id)sender;
- (IBAction)billButtonClicked:(id)sender;
- (IBAction)markectingButtonClicked:(id)sender;
- (IBAction)aboutUsButtonClicked:(id)sender;
- (IBAction)userFeedBackButtonClicked:(id)sender;
- (IBAction)jniiButtonClicked:(id)sender;
- (IBAction)nearbyHotelsClicked:(id)sender;
- (IBAction)searchHotelsClicked:(id)sender;
-(IBAction)shakeAwardClicked:(id)sender;

- (const unsigned int)getVersionNumber:(NSString *)version;

@end
