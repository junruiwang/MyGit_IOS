//
//  PhotoWallOneUC.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-22.
//  Copyright 2011年 W+K. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#include <CoreGraphics/CoreGraphics.h>

#import "PhotoWallOneUC.h"

#import "GlobalFunction.h"

#define PHOTO_IMAGE_RECT CGRectMake(6, 6, 1024, 768)
#define ROTATE_ANGLE M_PI/2.0

#define FRAME_WIDTH 3

@implementation PhotoWallOneUC

@synthesize index=_index,delegate;

static PhotoWallOneUC *_cutPO=nil;
static NSInteger _selectIndex=-1;

+(NSString *)getSmallFile:(NSString *)str{
    NSMutableArray *arr=(NSMutableArray*)[str componentsSeparatedByString:@"/"] ;
    NSString *tem=[arr objectAtIndex:[arr count]-1];
    tem=[NSString stringWithFormat:@"s%@",tem];
    [arr replaceObjectAtIndex:[arr count]-1 withObject:tem];
    tem=[arr componentsJoinedByString:@"/"];
    return tem;
}
+(void)selectIndex:(NSInteger)i{
    if(_cutPO && _cutPO.index!=i){
        [_cutPO selectEd:NO];
    }
    _selectIndex=i;
}
+(NSInteger)selectIndex{
    return _selectIndex;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //outTween=nil;
        // overTween=nil;
        delegate=nil;
        _index=-1;
        
        imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,90,68)];
        
        outView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 68)];
        outView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        
        overView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 68)];
        overView.layer.borderWidth=FRAME_WIDTH;
        
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        const CGFloat myColor[] = {21.0f/256.0f,71.0f/256.0f,156.0f/256.0f,1.0f};
        
        CGColorRef bc=CGColorCreate(rgb, myColor);
        overView.layer.borderColor=bc;
        overView.alpha=0;
        CGColorSpaceRelease(rgb);
        CGColorRelease(bc);
        
        imageView.userInteractionEnabled=NO;
        overView.userInteractionEnabled=NO;
        outView.userInteractionEnabled=NO;
        
        
        [self addSubview:imageView];
        [self addSubview:outView];
        [self addSubview:overView];
        
        [self addTarget:self action:@selector(clickHandler:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
-(IBAction) clickHandler:(id)sender {
    if(delegate){
        [delegate selectPo:_index];
    }
    //[self selectEd:YES];
}


-(void)showFrame:(BOOL)b{
    
    
    NSAutoreleasePool * pool = [ [ NSAutoreleasePool alloc ] init ] ;
    if(b){
        [GlobalFunction fadeInOut:overView to:1 time:0.3 hide:NO];
        [GlobalFunction fadeInOut:outView to:0 time:0.3 hide:NO];
        
        //[PRTween removeTweenOperation:overTween];
        //overTween=[PRTween tween:overView property:@"alpha" from:overView.alpha to:1 duration:0.3];
        
        //[PRTween removeTweenOperation:outTween];
        //outTween=[PRTween tween:outView property:@"alpha" from:outView.alpha to:0 duration:0.3];
    }else{
        [GlobalFunction fadeInOut:overView to:0 time:0.3 hide:NO];
        [GlobalFunction fadeInOut:outView to:1 time:0.3 hide:NO];
        
        //[PRTween removeTweenOperation:overTween];
        //overTween=[PRTween tween:overView property:@"alpha" from:overView.alpha to:0 duration:0.3];
        
        //[PRTween removeTweenOperation:outTween];
        //outTween=[PRTween tween:outView property:@"alpha" from:outView.alpha to:1 duration:0.3];
    }
    [pool release];  
}
-(void)selectEd:(BOOL)b{
    if(b){
        //openPo
        if(_cutPO !=self){
            [_cutPO selectEd:NO];
        }
        _selectIndex=_index;
        _cutPO=self;
        [self showFrame:YES];
        
    }else{
        if(_cutPO==self){
            _cutPO=nil;
            //selectIndex=-1;
        }
        [self showFrame:NO];
    }
    
    
}
-(void)setData:(NSString *)dic index:(NSInteger)index{
    if(_index==index){
        [self selectEd:YES];
        return;
    }
    //[PRTween removeTweenOperation:overTween];
    // [PRTween removeTweenOperation:outTween];
    
    UIImage *image=[[UIImage alloc] initWithContentsOfFile:[PhotoWallOneUC getSmallFile:dic]];
    imageView.image=image;
    [image release];
    _index=index;
    if(_selectIndex==_index){
        if(_cutPO !=self){
            [_cutPO selectEd:NO];
        }
        _cutPO=self;
        outView.alpha=0;
        overView.alpha=1;
    }else{
        if(_cutPO==self){
            _cutPO=nil;
            //selectIndex=-1;
        }
        outView.alpha=1;
        overView.alpha=0;
    }
}
- (void)dealloc
{
    if(_cutPO==self){
        _cutPO=nil;
        //selectIndex=-1;
    }
    // [PRTween removeTweenOperation:overTween];
    //[PRTween removeTweenOperation:outTween];
    RemoveRelease(imageView);
    RemoveRelease(outView);
    RemoveRelease(overView);
    [super dealloc];
}
@end
