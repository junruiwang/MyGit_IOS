//
//  RootWindowUI.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-2.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JJUIViewController;

@interface RootWindowUI : UIWindow {
    JJUIViewController *touchView;
    BOOL isReady;
    BOOL isClose;
}
@property  (nonatomic,assign)BOOL isClose;

+(id)sharedInstance;
+(void)shareRelease;

-(void)closeTouch;
-(void)setTouchView:(JJUIViewController *)view;
+(void)setTouchView:(JJUIViewController *)view;
+(void)closeOpen:(BOOL)b;
@end
