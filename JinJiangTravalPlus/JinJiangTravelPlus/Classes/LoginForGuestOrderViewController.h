//
//  LoginForOrderViewController.h
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 13-4-26.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginParser.h"
#import "UserInfo.h"

@protocol LoginForGuestOrderViewControllerDelegate <NSObject>

- (void) guestLoginAfterProcess : (UserInfo *) userInfo;
- (void) guestLoginClose;

@end

@interface LoginForGuestOrderViewController : UIViewController <GDataXMLParserDelegate>

@property (nonatomic, strong) UserInfo *userInfo;

@property (nonatomic, weak) IBOutlet UITextField *userName;

@property (nonatomic, weak) IBOutlet UITextField *passWord;

@property (nonatomic, strong) LoginParser *loginParser;

@property (nonatomic, weak) id<LoginForGuestOrderViewControllerDelegate> delegate;

- (IBAction) login : (id)sender;

@end
