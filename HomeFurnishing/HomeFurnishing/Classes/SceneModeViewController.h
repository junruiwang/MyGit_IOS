//
//  SceneModeViewController.h
//  HomeFurnishing
//
//  Created by jrwang on 14-12-7.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SceneModeViewController : BaseViewController

@property(nonatomic,weak) IBOutlet UIImageView *loadingView;

-(IBAction)systemButtonClick:(id)sender;

@end

