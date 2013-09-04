//
//  ClubVC.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "ClubVC.h"

#import "GlobalFunction.h"
#import "MainNC.h"
#import "NavigationView.h"
#import "jinjiangViewController.h"
#import "OmnitureManager.h"



@implementation ClubVC


-(void)showPage:(NSInteger)i{
    if(i!=index){
        if(index>=0 && index<[btns count]){
            UIButton *btn=[btns objectAtIndex:index];
            btn.selected=NO;
            btn.userInteractionEnabled=YES;
        }
        index=i;
        if(index>=0 && index<[btns count]){
            UIButton *btn=[btns objectAtIndex:index];
            btn.selected=YES;
            btn.userInteractionEnabled=NO;
        }
        if(index==0){
            if(vipView!=nil){
                //                RemoveRelease(vipView);
                [GlobalFunction fadeInOut:vipView to:0 time:0.4 hide:YES];
            }
            // RemoveRelease(vipView);
            if(magzineView==nil){
                magzineView=[[MagzineView alloc] initWithFrame:FULLRECT];
                [magzineView setCTView:controlView ctv:ctv];
                magzineView.clubVC = self;
                magzineView.alpha=0;
                [magzineView getMagzines];
            }
            [self.view insertSubview:magzineView atIndex:0];
            [GlobalFunction fadeInOut:magzineView to:1 time:0.4 hide:NO];
        }else{
            if(magzineView!=nil){
                //                RemoveRelease(magzineView);
                [GlobalFunction fadeInOut:magzineView to:0 time:0.4 hide:YES];
            }
            //RemoveRelease(magzineView);
            if(vipView==nil){
                vipView=[[VipView alloc] initWithFrame:FULLRECT];
                vipView.alpha=0;
            }
            [self.view insertSubview:vipView atIndex:0];
            [GlobalFunction fadeInOut:vipView to:1 time:0.4 hide:NO];
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
    [vars setValue:@"锦江杂志页面" forKey:@"pageName"];
    [vars setValue:@"礼享锦江" forKey:@"channel"];
    [OmnitureManager trackWithVariables:vars];
    
    RemoveRelease(ctv);
    RemoveRelease(magzineView);
    RemoveRelease(vipView);
    
    ControlTopView *temTop;
    
    temTop=[[ControlTopView alloc] initWithFrame:TOPRECT];
    
    
    [GlobalFunction addImage:temTop name:@"top_bg.png" rect:CGRectMake((151+166+151), 0, 1024-(151+166+151), TOPFULLHEIGHT)];
    
    
    UIButton *but;
    
    but=[ControlView getTopButtom:0 width:150];
    but.tag=100;
    [btns addObject:but];
    [GlobalFunction addImage:but name:@"6_title_btn_0.png" point:CGPointMake(16, 10)];
    
    [but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [temTop addSubview:but];
    
    [GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(150, 0, 1, TOPHEIGHT)];
    
    but=[ControlView getTopButtom:151 width:165];
    but.tag=101;
    [btns addObject:but];
    [GlobalFunction addImage:but name:@"6_title_btn_1.png" point:CGPointMake(16, 10)];
    
    [but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [temTop addSubview:but];
    [GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(151+165, 0, 1, TOPHEIGHT)];
    
    but=[ControlView getTopButtom:151+166 width:150];
    but.tag=102;
    [btns addObject:but];
    [GlobalFunction addImage:but name:@"6_title_btn_2.png" point:CGPointMake(16, 10)];
    
    [but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [temTop addSubview:but];
    
    [GlobalFunction addImage:temTop name:@"top_w_line.png" rect:CGRectMake(151+166+150, 0, 1, TOPHEIGHT)];
    
    
    
    [controlView addTop:temTop];
    [temTop release];
    
    
    ctv=[[ControlTopView alloc] initWithFrame:TOPRECT];
    
    [controlView addTop:ctv];
    
    
    
    [controlView showTop:0];
    
    [self.view addSubview:controlView];
    
    [self showPage:0];
    
}
- (void)viewDidUnload{
    RemoveRelease(ctv);
    RemoveRelease(magzineView);
    RemoveRelease(vipView);
    [super viewDidUnload];
}




-(void)setTouchMode:(NSInteger)mode point:(CGPoint)point{
    [super setTouchMode:mode point:point];
    if(mode==0){
        if(magzineView)[magzineView showHideBottom];
    }
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
            [jinjiangViewController showShare:1];
            break;
        case 103:
            [jinjiangViewController showShare:1];
            break;
        case 104:
            if(magzineView){
                [magzineView showPage:0 index:0];
            }
            break;
    }
}

-(void)outFun{
    NSLog(@"outFun");
    //    cacheImage=[[UIImageView alloc] initWithImage:[GlobalFunction imageFromView:self.view]];
    //    
    //    RemoveRelease(ctv);
    //    RemoveRelease(magzineView);
    //    RemoveRelease(vipView);
    //    
    //    [self.view addSubview:cacheImage]; 
}
- (void)dealloc
{
    RemoveRelease(cacheImage);
    NSLog(@"clubvc dealloc");
    RemoveRelease(ctv);
    RemoveRelease(magzineView);
    RemoveRelease(vipView);
    [super dealloc];
    
}


@end
