//
//  WireframeView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-15.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "WireframeView.h"
#import "GlobalFunction.h"

@implementation WireframeView

@synthesize thickness=_thickness;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    
    //画矩形
    //_thickness
    //self.frame.origin.x
    //CGPathMoveToPoint(path, NULL,0,0);
   // CGPathAddArcToPoint(path, NULL, 0, oy+rh, ox+r,oy+rh, r);
   // CGPathAddArcToPoint(path, NULL, ox+rw, oy+rh, ox+rw, oy+rh-r, r);
   // CGPathAddArcToPoint(path, NULL, ox+rw, oy, ox+rw-r, oy, r);
   // CGPathAddArcToPoint(path, NULL, ox, oy, ox,oy+r,r);
}


- (void)dealloc
{
    [super dealloc];
}

@end
