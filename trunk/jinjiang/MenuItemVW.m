//
//  MenuItemVW.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "MenuItemVW.h"

#import <QuartzCore/QuartzCore.h>

#import "GlobalFunction.h"

@implementation MenuItemVW

  

@synthesize menuItemDelegate;


static NSMutableArray *__indexArray = nil;

+(NSMutableArray *)getIndexArray{
    if(__indexArray==nil){
        __indexArray=[[NSMutableArray alloc] init];
        [__indexArray addObject:@"1"];
        [__indexArray addObject:@"2"];
        [__indexArray addObject:@"3"];
        [__indexArray addObject:@"4"];
        [__indexArray addObject:@"5"];
    }
    return  __indexArray;  
}

+(void)releaseIndexArray{
    Release2Nil(__indexArray); 
}

+ (id)initWithIndex:(NSInteger)index
{
    NSMutableArray *__indexArray=[MenuItemVW getIndexArray];
    MenuItemVW *mi = [[self alloc] initWithFrame:CGRectMake(index*257-2, 0, 257, 768) index:index];
    //mi.tag=index;
    if (mi) {
      mi.tag=[[__indexArray objectAtIndex:index] intValue]-1;
    }
    return mi;
}

- (void)cubeMoveOut:(NSString*) ii{
    
    //NSLog(@"::::%f::::%f",self.frame.origin.x,[ii floatValue]);
    bgView.image=[GlobalFunction getImageFromImage:[UIImage imageNamed:@"2_bg.png"] rect:CGRectMake(self.frame.origin.x-[ii floatValue], 0, 257, 768)];
    
    CATransition *animation = [CATransition animation];
    //animation.delegate = self;
    animation.duration = 0.6f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = @"cube";
    
    animation.subtype = kCATransitionFromLeft;
    
    NSUInteger bgIndex = [[self subviews] indexOfObject:bgView];
    NSUInteger imageIndex= [[self subviews] indexOfObject:imageView];
    
    [self exchangeSubviewAtIndex:bgIndex withSubviewAtIndex:imageIndex];
    
    [self.layer addAnimation:animation forKey:@"transitionViewAnimation"];
    
   
    
}
-(void)clickFun{
    if(menuItemDelegate){
        [menuItemDelegate select:self.tag];
    }
}

-(void)downFun{
    if(menuItemDelegate){
        
    }
}

-(void)upFun{
    if(menuItemDelegate){
       
    }
}

-(void)moveFun{
    if(menuItemDelegate){
        
    }
}

-(void)cancelDownFun{
    if(menuItemDelegate){
        
    }
}


- (id)initWithFrame:(CGRect)frame index:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
         NSMutableArray *__indexArray=[MenuItemVW getIndexArray];
        
        //bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 253, 768)];
       // bgView.UIImageView=[UIColor whiteColor];
        bgView=[[UIImageView alloc] initWithFrame:CGRectMake(-2, 0, 257, 768)];
        //bgView=[[UIImageView alloc] initWithImage:[self getImageFromImage:[UIImage imageNamed:@"1_bg.png"] rect:CGRectMake(257*(index), 0, 253, 768)]];

        //imageView=[[UIControl alloc] initWithFrame:CGRectMake(0, 0, 253, 768)];
        //UIImageView *ui=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"2_page%@.png",[__indexArray objectAtIndex:index]]]]; //(index+1)
        imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"2_page%@.png",[__indexArray objectAtIndex:index]]]]; //(index+1)
        imageView.frame=bgView.frame;
        //[imageView addSubview:ui];
        [self addSubview:bgView];
        [self addSubview:imageView];
        /*
        [imageView addTarget:self action:@selector(clickFun) forControlEvents:UIControlEventTouchUpInside];
        [imageView addTarget:self action:@selector(downFun) forControlEvents:UIControlEventTouchDown];
        [imageView addTarget:self action:@selector(upFun) forControlEvents:UIControlEventTouchUpInside];
        [imageView addTarget:self action:@selector(moveFun) forControlEvents:UIControlEventTouchUpInside];
        [imageView addTarget:self action:@selector(cancelDownFun) forControlEvents:UIControlEventTouchDownRepeat];

        imageView.userInteractionEnabled=NO;
         */
    }
    return self;
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
    NSLog(@"MenuItemVW dealloc::%d",self.tag);
     [self.layer removeAnimationForKey:@"transitionViewAnimation"];
     RemoveRelease(bgView);
     RemoveRelease(imageView);
    [super dealloc];
}

@end
