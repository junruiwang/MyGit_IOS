//
//  KalManager.h
//  JinJiangTravelPlus
//
//  Created by Leon on 11/20/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KalViewController.h"
#import "UINavigationBar+Categories.h"
#import "Constants.h"

@protocol KalManagerDelegate;

@interface KalManager : NSObject<KalCalendarDelegate>

@property (nonatomic, weak) id<KalManagerDelegate> delegate;
@property(nonatomic, assign) NSInteger nightNums;


- (id)initWithViewController:(UIViewController *)viewController;
- (void)pickDate;

@end

@protocol KalManagerDelegate <NSObject>

- (void)manager:(KalManager *)manager didSelectMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate;

@end
