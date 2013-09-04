//
//  AccelerometerFilter.h
//  Picnic
//
//  Created by Raphael.rong on 13-3-25.
//  Copyright (c) 2013年 Raphael.rong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAccelerometerMinStep				0.02
#define kAccelerometerNoiseAttenuation		3.0
#define kAccelerometerInterval              60
@interface AccelerometerFilter : NSObject
{
	UIAccelerationValue x, y, z;
	double filterConstant;
	UIAccelerationValue lastX, lastY, lastZ;
}


@property(nonatomic, readonly) UIAccelerationValue x;
@property(nonatomic, readonly) UIAccelerationValue y;
@property(nonatomic, readonly) UIAccelerationValue z;


// Add a UIAcceleration to the filter.
-(void)addAcceleration:(UIAcceleration*)accel;
-(id)initWithCutoffFrequency:(double)freq;


@end