//
//  DrawLineLabel.m
//  ChoiceCourse
//
//  Created by huguiqi on 12-12-9.
//
//

#import "DrawLineView.h"

@implementation DrawLineView



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.array_points = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
    NSLog(@"***********************");
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawLine:context];
}


- (void)drawLine:(CGContextRef)_context
{
    CGContextMoveToPoint(_context, _beginPoint.x, _beginPoint.y);
    CGContextAddLineToPoint(_context, _endPoint.x, _endPoint.y);
    CGContextSetLineWidth(_context, 5);
    CGContextSetRGBFillColor(_context, 0, 0, 0, 1);
    
    CGContextStrokePath(_context);
    if(_endPoint.x - _beginPoint.x>60){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"报名成功" message:@"恭喜，小老师报名成功喽!!" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertView show];
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.beginPoint = [touch locationInView:self];
    [_array_points addObject:[NSValue valueWithCGPoint:_beginPoint]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.endPoint = [touch locationInView:self];
    [_array_points addObject:[NSValue valueWithCGPoint:_endPoint]];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_array_points removeAllObjects];
}

@end
