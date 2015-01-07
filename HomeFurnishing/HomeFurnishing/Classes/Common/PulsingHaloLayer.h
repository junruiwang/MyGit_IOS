//
//  PulsingHaloLayer.h
//  IntelligentHome
//
//  Created by jerry on 13-10-9.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


@interface PulsingHaloLayer : CALayer

@property (nonatomic, assign) CGFloat radius;                   // default:60pt
@property (nonatomic, assign) NSTimeInterval animationDuration; // default:3s
@property (nonatomic, assign) NSTimeInterval pulseInterval; // default is 0s

@end
