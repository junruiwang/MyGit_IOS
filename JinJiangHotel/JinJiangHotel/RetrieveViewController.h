//
//  RetrieveViewController.h
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-16.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//


#import "JJViewController.h"
#import "RetrieveParser.h"


@interface RetrieveViewController : JJViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UIButton *retrieceButton;

@property (nonatomic, strong) RetrieveParser* retrieveParser;
@property (nonatomic, strong) NSTimer* timer;
@end
