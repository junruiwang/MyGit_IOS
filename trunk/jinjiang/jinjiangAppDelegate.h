//
//  jinjiangAppDelegate.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-26.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMeasurement.h"

@class jinjiangViewController,RootWindowUI;

@interface jinjiangAppDelegate : NSObject <UIApplicationDelegate> {
    RootWindowUI *window;
    AppMeasurement *measurement;
}

//@property (nonatomic, retain) IBOutlet UIWindow *window;

//@property (nonatomic, retain) RootWindowUI *window;

@end
