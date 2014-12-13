//
//  SettingIndexViewController.h
//  HomeFurnishing
//
//  Created by jrwang on 14-12-13.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ControllerFunction.h"

@interface SettingIndexViewController : BaseViewController

@property(nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property(nonatomic, weak) id<ControllerFunction> delegate;

-(IBAction)loginoutButtonClicked:(id)sender;
-(IBAction)backHome:(id)sender;

@end
