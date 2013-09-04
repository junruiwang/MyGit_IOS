//
//  MemoryView.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-12-2.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <mach/mach.h>
#import <mach/mach_host.h>

@interface MemoryView : UIView {
    UILabel *txtView;
       NSTimer *timer;
}
+(void)addTrack:(UIView *)view frame:(CGRect)rect;
@end
