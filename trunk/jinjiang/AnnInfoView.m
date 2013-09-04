//
//  AnnInfoView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-9.
//  Copyright 2011年 W+K. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#include <CoreGraphics/CoreGraphics.h>
#import "AnnInfoView.h"

#import "GlobalFunction.h"
#import "JJMKAnnotationView.h"



#define ANNINFOSHOWRECT CGRectMake(-260, -134, 382, 149)

#define ANNINFOINITRECT CGRectMake(-270, -134, 382, 149)

//#define ANNINFOSHOWRECT CGRectMake(0, 0, 382, 149)

//#define ANNINFOINITRECT CGRectMake(0, -10, 382, 149)


@implementation AnnInfoView

static AnnInfoView *annInfoView=nil;


- (id)initWithDic:(NSDictionary *)dic
{
    
    self = [super initWithFrame:ANNINFOINITRECT];//15
    if (self) {
        // Initialization code
        if(annInfoView!=nil && annInfoView!=self){
            [annInfoView removeOut];
        }
        annInfoView=self;
        data=dic;
        self.alpha=0;
        [GlobalFunction addImage:self name:@"5_map_click_bg.png"];
        [GlobalFunction fadeInOut:self to:1 time:0.4 hide:NO];
        [GlobalFunction moveView:self to:ANNINFOSHOWRECT time:0.4];
        
        //self.layer.cornerRadius
        
          //5_text_line
        [GlobalFunction addImage:self name:@"5_text_line.png" rect:CGRectMake(190, 86, 146, 2)];
        
        UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [but setImage:[UIImage imageNamed:@"5_list_btn.png"] forState:UIControlStateNormal];
        but.frame=CGRectMake(190, 96, 71, 16);
        but.bounds= CGRectMake(but.frame.origin.x-20,but.frame.origin.y-30, but.frame.size.width+40, but.frame.size.height+60);
        //[but setImage:[UIImage imageNamed:@"m_bg_s.png"] forState:UIControlStateSelected];
        [but addTarget:self action:@selector(linkToWeb) forControlEvents:UIControlEventTouchDown];
        
        [GlobalFunction setTxtColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
        
        [GlobalFunction addLabelLeft:self copy:[data objectForKey:@"HotelName"] frame:CGRectMake(190, 20, 164, 34) size:16 lines:2];
        [GlobalFunction addLabelLeft:self copy:[data objectForKey:@"HotelAddress"] frame:CGRectMake(190, 44, 157, 52) size:12 lines:2];
        
        //LoadImageView *
        loadImage=[[LoadImageView alloc] initWithFrame:CGRectMake(14, 13, 162, 115)];
        //loadImage.backgroundColor=[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
        loadImage.layer.cornerRadius=5;
        loadImage.layer.masksToBounds=YES;
        [loadImage loadImage:[data objectForKey:@"HotelImgUrl"]];
        
        //NSLog(@"[data objectForKey:HotelImgUrl]:::%@::%@",[data objectForKey:@"HotelImgUrl"],[data objectForKey:@"HotelName"]);
        
        [self addSubview:loadImage];
        
        [self addSubview:but];
        
        //[loadImage release];
    }
    return self;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hit=nil;
    NSArray *nr=self.subviews;
    for (NSInteger i=0;i<[nr count];i++){
        UIView *temView=[nr objectAtIndex:i];
        CGPoint temPoint=[self convertPoint:point toView:temView];
        
        hit= [temView hitTest:temPoint withEvent:event];
        if(hit!=nil){
            // [GlobalFunction closeTouch];
            return hit;
        }
        
        
    }
    if(annInfoView==self){
       [self removeOut];
    }
    
    return nil;
}
-(void)linkToWeb{
    //NSLog(@"HotelDetailLink::::");
    //[data objectForKey:@"HotelDetailLink"]
    if([data objectForKey:@"HotelDetailLink"]){
        [jinjiangViewController toLink:[data objectForKey:@"HotelDetailLink"]];
    }
}
-(void)removeOut{
    if(annView!=nil){
        [annView killInfo];
    }
    if(annInfoView==self){
        annInfoView=nil;
    }
    [GlobalFunction fadeInOut:self to:0 time:0.4 hide:YES];
    [GlobalFunction moveView:self to:ANNINFOINITRECT time:0.4];
}
-(void)removeFromSuperview{
    if(annView!=nil){
        [annView killInfo];
    }

    if(annInfoView==self){
        annInfoView=nil;
    }
    [super removeFromSuperview];
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
    if(loadImage){
        [loadImage clear];
    }
    RemoveRelease(loadImage);
    if(annView!=nil){
        [annView killInfo];
    }

    if(annInfoView==self){
        annInfoView=nil;
    }
    [super dealloc];
}

@end
