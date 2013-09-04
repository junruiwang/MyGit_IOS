//
//  AboutVC.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "AboutVC.h"

#import "GlobalFunction.h"
#import "MainNC.h"
#import "NavigationView.h"
#import "jinjiangViewController.h"
#import "OmnitureManager.h"


@implementation AboutVC


-(void)showPage:(NSInteger)i{
    if(i!=index){
        
        UIButton *b1=(UIButton *)[ct0 viewWithTag:index+100];
        UIButton *b2=(UIButton *)[ct1 viewWithTag:index+100];
        
        if([b1 isKindOfClass:[UIButton class]]){
            b1.selected=NO;
            b1.userInteractionEnabled=YES;
        }
        if([b2 isKindOfClass:[UIButton class]]){
            b2.selected=NO;
            b2.userInteractionEnabled=YES;
        }
        
        index=i;
        
        b1=(UIButton *)[ct0 viewWithTag:index+100];
        b2=(UIButton *)[ct1 viewWithTag:index+100];
    
        
        if([b1 isKindOfClass:[UIButton class]]){
            b1.selected=YES;
            b1.userInteractionEnabled=NO;
        }
        if([b2 isKindOfClass:[UIButton class]]){
            b2.selected=YES;
            b2.userInteractionEnabled=NO;
        }

        if(index==0){
            if(contactView!=nil){
                RemoveRelease(contactView);
                //[GlobalFunction fadeInOut:contactView to:0 time:0.4 hide:YES];
            }
            if(infoView==nil){
                infoView=[[InfoView alloc] initWithFrame:FULLRECT];
                [infoView setControlView:controlView];
                infoView.alpha=0;
            }
            [self.view insertSubview:infoView atIndex:0];
            [GlobalFunction fadeInOut:infoView to:1 time:0.4 hide:NO];
            [controlView showTop:0];
        }else{
            
            if(infoView!=nil){
                RemoveRelease(infoView);
                //[GlobalFunction fadeInOut:infoView to:0 time:0.4 hide:YES];
            }
            if(contactView==nil){
                contactView=[[ContactView alloc] initWithFrame:FULLRECT];
                contactView.alpha=0;
            }
            [self.view insertSubview:contactView atIndex:0];
            [GlobalFunction fadeInOut:contactView to:1 time:0.4 hide:NO];
            [controlView showTop:0];
        }
    }
}


- (void)loadView
{
    [super loadView];
    
    index=-1;

}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSMutableDictionary *vars = [NSMutableDictionary dictionary];
    [vars setValue:@"了解锦江页面" forKey:@"pageName"];
    [vars setValue:@"了解锦江" forKey:@"channel"];
    [OmnitureManager trackWithVariables:vars];
    
    RemoveRelease(ct0);
    RemoveRelease(ct1);
    
    RemoveRelease(infoView);
    RemoveRelease(contactView);
    
    ControlTopView *temTop;
    
    temTop=[[ControlTopView alloc] initWithFrame:TOPRECT];
    
    
    [GlobalFunction addImage:temTop name:@"top_bg.png" rect:CGRectMake(144+171+144, 0, 1024-(144+171+144), 56)];
    
    
    UIButton *but;
    
    but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setBackgroundImage:[UIImage imageNamed:@"8_title_btn0.png"] forState:UIControlStateNormal];
    [but setBackgroundImage:[UIImage imageNamed:@"8_title_btn0_o.png"] forState:UIControlStateHighlighted];
    [but setBackgroundImage:[UIImage imageNamed:@"8_title_btn0_o.png"] forState:UIControlStateSelected];
    but.frame = CGRectMake(0,0, 170, 56);
    but.tag=100;
    
    
    
    [but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [temTop addSubview:but];
    
    [GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(170, 0, 1, TOPHEIGHT)];
    
    but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setBackgroundImage:[UIImage imageNamed:@"8_title_btn1.png"] forState:UIControlStateNormal];
    [but setBackgroundImage:[UIImage imageNamed:@"8_title_btn1_o.png"] forState:UIControlStateHighlighted];
    [but setBackgroundImage:[UIImage imageNamed:@"8_title_btn1_o.png"] forState:UIControlStateSelected];
    but.frame = CGRectMake(171,0, 143, 56);
    but.tag=101;
    
    [but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [temTop addSubview:but];
    
    [GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(143+171, 0, 1, TOPHEIGHT)];
    
    
    
    but=[ControlView getTopButtom:144+171 width:143];
    but.tag=103;
    [GlobalFunction addImage:but name:@"6_title_btn_2.png" point:CGPointMake(16, 10)];
    
    [but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [temTop addSubview:but];
    
    [GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(144+171+143, 0, 1, TOPHEIGHT)];
    
    
    [controlView addTop:temTop];
    
    //[temTop release];
    
    ct0=temTop;
    
    //////////top2
    
    temTop=[[ControlTopView alloc] initWithFrame:TOPRECT];
    
    
    [GlobalFunction addImage:temTop name:@"top_bg.png" rect:CGRectMake(144+171+144, 0, 1024-144-171-81-144, 56)];
    
    
    
    but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setBackgroundImage:[UIImage imageNamed:@"8_title_btn0.png"] forState:UIControlStateNormal];
    [but setBackgroundImage:[UIImage imageNamed:@"8_title_btn0_o.png"] forState:UIControlStateHighlighted];
    [but setBackgroundImage:[UIImage imageNamed:@"8_title_btn0_o.png"] forState:UIControlStateSelected];
    but.frame = CGRectMake(0,0, 170, 56);
    but.tag=100;
    
    
    
    [but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [temTop addSubview:but];
    
    [GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(170, 0, 1, TOPHEIGHT)];
    
    but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setBackgroundImage:[UIImage imageNamed:@"8_title_btn1.png"] forState:UIControlStateNormal];
    [but setBackgroundImage:[UIImage imageNamed:@"8_title_btn1_o.png"] forState:UIControlStateHighlighted];
    [but setBackgroundImage:[UIImage imageNamed:@"8_title_btn1_o.png"] forState:UIControlStateSelected];
    but.frame = CGRectMake(171,0, 143, 56);
    but.tag=101;
    
    [but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [temTop addSubview:but];
    
    [GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(143+171, 0, 1, TOPHEIGHT)];
    
    
    but=[ControlView getTopButtom:144+171 width:143];
    but.tag=103;
    [GlobalFunction addImage:but name:@"6_title_btn_2.png" point:CGPointMake(16, 10)];
    
    [but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [temTop addSubview:but];
    
    [GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(144+171+143, 0, 1, TOPHEIGHT)];
    
    
    
    
    
    
    but=[ControlView getTopButtom:1024-80 width:80];
    
    [GlobalFunction addImage:but name:@"8_s12_btn1.png" point:CGPointMake(12, 14)];
    but.tag=102;
    
    [but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [temTop addSubview:but];
    
    [GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(1024-81, 0, 1, TOPHEIGHT)];
    
    
    [controlView addTop:temTop];
    
    //[temTop release];
    ct1=temTop;
    
    [controlView showTop:0];
    
    [self.view addSubview:controlView];
    
    [self showPage:0];
    
    
    
}
- (void)viewDidUnload{
    
    RemoveRelease(ct0);
    RemoveRelease(ct1);
    
    RemoveRelease(infoView);
    RemoveRelease(contactView);
    
    [super viewDidUnload];
}

-(void)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger ii=btn.tag;
    switch (ii) {
        case 100:
            [self showPage:0];
            break;
        case 101:
            [self showPage:1];
            break;
        case 102:
            [infoView showPage:0];
            break;
        case 103:
            [jinjiangViewController showShare:4];
            break;
    }
    //  [jinjiangViewController showShare:4];
}

-(void)outFun{
    //NSLog(@"outFun");
    cacheImage=[[UIImageView alloc] initWithImage:[GlobalFunction imageFromView:self.view]];
    [self.view addSubview:cacheImage];
    
    RemoveRelease(ct0);
    RemoveRelease(ct1);
    
    RemoveRelease(infoView);
    RemoveRelease(contactView);
}
- (void)dealloc
{
    NSLog(@"about dealloc");
    RemoveRelease(cacheImage);
    RemoveRelease(ct0);
    RemoveRelease(ct1);
    
    RemoveRelease(infoView);
    RemoveRelease(contactView);
    [super dealloc];
    
}

@end
