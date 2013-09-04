//
//  HelpVC.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "HelpVC.h"
#import "GlobalFunction.h"
#import "MainNC.h"
#import "NavigationView.h"
#import "jinjiangViewController.h"

@implementation HelpVC
- (void)loadView
{
     [super loadView];
    //1_help
    bgUI=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1_bg.png"]]; 
    guideUI=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2_guide.png"]]; 
       
    guideUI.alpha=0;
    
    
    nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(777, 60, 194, 48);
    nextBtn.tag = 1;
    [nextBtn setImage:[UIImage imageNamed:@"2_btn.png"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.alpha=0;
    
    //344 344 
    [self.view addSubview:bgUI];
    [self.view addSubview:guideUI];
    [self.view addSubview:nextBtn];
   

    
    [GlobalFunction fadeInOut:guideUI to:1 time:0.6 hide:NO];
    [GlobalFunction fadeInOut:nextBtn to:1 time:0.6 hide:NO];
   

}
- (void)viewDidLoad{
    
    [super viewDidLoad];
}
- (void)viewDidUnload{
    
    [super viewDidUnload];
}
- (void)nextBtnClicked
{
    [NavigationView select:2 mode:0];
}

-(void)outFun{
    NSLog(@"outFun");
    cacheImage=[[UIImageView alloc] initWithImage:[GlobalFunction imageFromView:self.view]];
    [self.view addSubview:cacheImage];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    RemoveRelease(bgUI);
    RemoveRelease(guideUI);
    Remove2Nil(nextBtn);
    
}
- (void)dealloc
{
   
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    RemoveRelease(cacheImage);
    
    RemoveRelease(bgUI);
    RemoveRelease(guideUI);
    Remove2Nil(nextBtn);
    [super dealloc];
    
}



@end
