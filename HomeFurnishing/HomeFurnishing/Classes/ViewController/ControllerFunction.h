//
//  ControllerFunction.h
//  HomeFurnishing
//
//  Created by jerry on 14/12/11.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kLoginView = 0,
    kSceneModeView,
    kSettingIndexView,
} HFController;

@protocol ControllerFunction <NSObject>

@optional

- (void)dismissViewController:(HFController) viewController;

@end
