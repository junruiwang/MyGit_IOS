//
//  AppDelegate.h
//  ChoiceCourse
//
//  Created by 汪君瑞 on 12-11-14.
//
//

#import <UIKit/UIKit.h>
#import "GAI.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) id<GAITracker> tracker;

@end
