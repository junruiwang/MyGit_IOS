//
//  JYTween.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-24.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "JYTween.h"


@implementation JYTween
static NSTimer *timer=nil;
static NSMutableArray *tweenObjs=nil;
+(void)update{
    NSMutableArray *temLsit=[[NSMutableArray alloc] init];
    
}

+(JYTweenObject *)addTween:(id) to:(CGFloat)value time:(CGFloat)time getSel:(SEL)getSel setSel:(SEL)setSel delay:(CGFloat)delay{
    JYTweenObject *tobj;
       
    return tobj;
}
+(JYTweenObject *)addTween:(id) to:(CGFloat)value time:(CGFloat)time getSel:(SEL)getSel setSel:(SEL)setSel delay:(CGFloat)delay startSel:(SEL)startSel updateSel:(SEL)updateSel endSel:(SEL)endSel{
    JYTweenObject *tobj;
    
    return tobj;
}
+(JYTweenObject *)addTween:(id) to:(CGFloat)value time:(CGFloat)time getSel:(SEL)getSel setSel:(SEL)setSel delay:(CGFloat)delay startSel:(SEL)startSel updateSel:(SEL)updateSel endSel:(SEL)endSel ease:(SEL)ease{
    JYTweenObject *tobj;
        if(timer==nil){
            timer=[[NSTimer alloc] initWithFireDate:nil interval:1.0/60.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
            
        }
        if(tweenObjs==nil){
            tweenObjs=[[NSMutableArray alloc] init];
        }
    
    return tobj;
}


@end
