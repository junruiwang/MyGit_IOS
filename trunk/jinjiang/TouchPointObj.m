//
//  TouchPointObj.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-28.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "TouchPointObj.h"


@implementation TouchPointObj

@synthesize origin,time,touch;

- (void)dealloc
{
    
    self.touch=nil;
    [super dealloc];
    
}

+(double)calculateDis:(CGPoint)p1 p0:(CGPoint)p0{
    return sqrt((p1.x-p0.x)*(p1.x-p0.x)+(p1.y-p0.y)*(p1.y-p0.y));
}
+(double)calculateRotate:(CGPoint)p1 p0:(CGPoint)p0
{
    //printf("......p1.x=%.2f, p1.y=%.2f, p0.x=%.2f, p0.y=%.2f ......\n", p1.x, p1.y, p0.x, p0.y);
    
    double rotateDegree = atan2(fabs(p1.x-p0.x),fabs(p1.y-p0.y)) * 180.0 / M_PI;
    
    //printf("......rorate degree=%.2f......\n", rotateDegree);
    
    //如果p1纵坐标大于原点p0纵坐标(在第一和第二象限)
    if (p1.y>=p0.y)
    {
        if (p1.x>=p0.x) //第一象限
        {
            rotateDegree = 180.0 + rotateDegree;
        }
        else //第二象限
        {
            rotateDegree = 180.0 - rotateDegree;
        }
    }
    else //第三和第四象限
    {
        if (p1.x<=p0.x) //第三象限，不做任何处理
        {
            
        }
        else //第四象限
        {
            rotateDegree = 360.0 - rotateDegree;
        }
    }
    return rotateDegree;
}


@end
