//
//  PromotionListCell.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "PromotionListCell.h"

#import "GlobalFunction.h"

#import <QuartzCore/QuartzCore.h>

@implementation PromotionListCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        data=nil;
        
        imageView=[[LoadImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 192)];
    
        imageView.delegate=self;

        self.backgroundColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        // Initialization code
        //7_link_btn 7_share_btn
        //100 34   43 34
       
        linkBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        linkBtn.tag=100;
        linkBtn.frame = CGRectMake(80, 128, 100, 34);
        [linkBtn setImage:[UIImage imageNamed:@"7_link_btn.png"] forState:UIControlStateNormal];
        [linkBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.tag=101;
        shareBtn.frame = CGRectMake(180, 128, 43, 34);
        [shareBtn setImage:[UIImage imageNamed:@"7_share_btn.png"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
         UIButton *imageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.tag=102;
        imageBtn.backgroundColor=[UIColor clearColor];
        imageBtn.frame = CGRectMake(312, 0, 1024-312, 192);
        [imageBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:imageView];
        
        [self addSubview:linkBtn];
        [self addSubview:shareBtn];
        [self addSubview:imageBtn];
        
        linkBtn.alpha=0.0;
        shareBtn.alpha=0.0;
        //self.clipsToBounds=NO;
        self.userInteractionEnabled=NO;
        
        self.layer.shadowOffset=CGSizeMake(-3, 0);
        self.layer.shadowRadius=6;
        self.layer.shadowOpacity=0.5;
        self.layer.shadowColor=[UIColor blackColor].CGColor;
            
    }
    return self;
}
-(void)btnClicked:(id)sender{
    UIButton *btn=(UIButton *)sender;
    if(btn.tag==100 || btn.tag==102){
        if([data objectForKey:@"link"]){
            [jinjiangViewController toLink:[data objectForKey:@"link"]];
        }
    }else if(btn.tag==101){
        if([data objectForKey:@"share"]){
            [jinjiangViewController showShare:3];
        }
    }
    
}
-(void)setData:(NSDictionary *)dic isInit:(BOOL)ii{
    Release2Nil(data);
    data=[dic retain];
    loaded=NO;
    if(imageView)[imageView reSet];
    [imageView loadImage:[dic objectForKey:@"image"] fadeIn:ii];
    if(loaded){
        linkBtn.alpha=1.0;
        shareBtn.alpha=1.0;
    }else{
        loaded=YES;
        linkBtn.alpha=0.0;
        shareBtn.alpha=0.0;
        self.userInteractionEnabled=NO;
    }
   
    
   
}
-(void)loadComplete:(LoadImageView *)loadImage{
    self.userInteractionEnabled=YES;
    if(loaded){
        [PRTween tween:linkBtn property:@"alpha" from:0 to:1 duration:0.3];
        [PRTween tween:shareBtn property:@"alpha" from:0 to:1 duration:0.3];
    }
    loaded=YES;
}

- (void)dealloc
{
    if(imageView)[imageView clear];
    Release2Nil(data);
    RemoveRelease(imageView);
    [super dealloc];
}

@end
