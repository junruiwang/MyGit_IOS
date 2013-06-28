//
//  BannerViewController.h
//  WeatherReport
//
//  Created by jerry on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "GAI.h"

@interface BannerViewController : GAITrackedViewController

- (void)showAlertMessage:(NSString *)msg;

@end
