//
//  RetrievePwdViewController.h
//  JinJiangTravelPlus
//
//  Created by 杨 栋栋 on 13-1-31.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RetrieveParser.h"

@protocol TimerDelegate <NSObject>

- (void) timerFired :(NSTimer *)timer ;

@end

@interface RetrievePwdViewController : JJViewController <UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField* telePhoneTextFeild;
@property (nonatomic, weak) IBOutlet UIButton* sendButton;
@property (nonatomic, weak) IBOutlet UILabel* telePhoneTextLabel;

@property (nonatomic, strong) RetrieveParser* retrieveParser;
@property (nonatomic, strong) NSTimer* timer;

- (IBAction)retrieve:(id)sender;

@end
