//
//  TouchPointObj.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-28.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
typedef struct {
    CGPoint origin;
    NSInteger time;
    id touch;
}TouchPoint;
*/

@interface TouchPointObj : NSObject {
    CGPoint origin;
    NSInteger time;
    id touch;
}

@property  (nonatomic,assign)CGPoint origin;
@property  (nonatomic, assign)NSInteger time;
@property  (nonatomic, retain)id touch;

+(double)calculateRotate:(CGPoint)p1 p0:(CGPoint)p0;
+(double)calculateDis:(CGPoint)p1 p0:(CGPoint)p0;
@end
