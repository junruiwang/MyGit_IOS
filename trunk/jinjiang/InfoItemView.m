//
//  InfoItemView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "InfoItemView.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalFunction.h"

@implementation InfoItemView

- (id)initWithFrame:(CGRect)frame index:(NSInteger)index;
{
    self = [super initWithFrame:frame];
    if (self) {
        _index=index;
        // Initialization code
        bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgView.backgroundColor=[UIColor whiteColor];
        //NSLog(@"pic::%@",[NSString stringWithFormat:@"8_s1_%d.png",index+1]);
        imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"8_s1_%d.png",index+1]]];
        imageView.frame=bgView.frame;
        
       
        //[imageView addSubview:ui];
        [self addSubview:bgView];
        [self addSubview:imageView];
        
        bgView.userInteractionEnabled=NO;
        imageView.userInteractionEnabled=NO;
        
        self.userInteractionEnabled=YES;
        
    }
    return self;
}
-(void)cubeMoveIn{
    
    CATransition *animation = [CATransition animation];
    
    //animation.delegate = self;
    animation.duration = 0.6f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = @"cube";
    
    animation.subtype = kCATransitionFromTop;
    
    NSUInteger bgIndex = [[self subviews] indexOfObject:imageView];
    NSUInteger imageIndex= [[self subviews] indexOfObject:bgView];
    
    [self exchangeSubviewAtIndex:bgIndex withSubviewAtIndex:imageIndex];
    
    [self.layer addAnimation:animation forKey:@"infoTransitionViewAnimation"];
    

}
- (void)cubeMoveOut{
    //
    //NSLog(@"::::%f::::%f",self.frame.origin.x,[ii floatValue]);
    CATransition *animation = [CATransition animation];
    
    //animation.delegate = self;
    animation.duration = 0.6f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = @"cube";
    
    animation.subtype = kCATransitionFromBottom;
    
    NSUInteger bgIndex = [[self subviews] indexOfObject:bgView];
    NSUInteger imageIndex= [[self subviews] indexOfObject:imageView];
    
    [self exchangeSubviewAtIndex:bgIndex withSubviewAtIndex:imageIndex];
    
    [self.layer addAnimation:animation forKey:@"infoTransitionViewAnimation"];
     
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    NSLog(@"InfoItemView  dealloc");
    [self.layer removeAnimationForKey:@"infoTransitionViewAnimation"];
    RemoveRelease(bgView);
    RemoveRelease(imageView);
    [super dealloc];
}

@end
