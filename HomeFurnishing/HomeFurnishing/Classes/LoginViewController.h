//
//  LoginViewController.h
//  HomeFurnishing
//
//  Created by jrwang on 14-12-11.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ControllerFunction.h"

@interface LoginViewController : BaseViewController

@property(nonatomic, weak) id<ControllerFunction> delegate;

-(IBAction)cancelLoginClicked:(id)sender;

@end