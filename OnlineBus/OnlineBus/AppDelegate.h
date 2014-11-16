//
//  AppDelegate.h
//  OnlineBus
//
//  Created by jerry on 13-12-4.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "GAI.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) id<GAITracker> tracker;

@end
