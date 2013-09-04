//
//  IntroVC.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "IntroVC.h"
#import "GlobalFunction.h"
#import "MainNC.h"
#import "NavigationView.h"
#import "jinjiangViewController.h"

@implementation IntroVC




- (void)loadView
{
   [super loadView];
   // /*
    //1_help
    //bgUI=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1_bg.png"]]; 
    logoUI=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1_logo.png"]]; 
    helpUI=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1_help.png"]]; 
    //266 334 1024-
    
    logoUI.frame=CGRectMake(379,217, 266, 334);
    logoUI.alpha=0.0f;
    
    helpUI.frame=CGRectMake(344,212, 344, 344);
    helpUI.alpha=0;
    //344 344 
    //[self.view addSubview:bgUI];
    [self.view addSubview:logoUI];
    
    
    [GlobalFunction fadeInOut:logoUI to:1 time:0.6 hide:NO];
    
    [self performSelector:@selector(showHelp) withObject:nil afterDelay:3];
    
}
- (void)viewDidLoad{
    
    [super viewDidLoad];
}
- (void)viewDidUnload{
    
    [super viewDidUnload];
}
-(void)hideHelp{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [GlobalFunction fadeInOut:helpUI to:0 time:0.6 hide:YES];
    [self performSelector:@selector(showHelp) withObject:nil afterDelay:3.6f];
   
}
-(void)showHelp{
    [self.view addSubview:helpUI];
    [GlobalFunction fadeInOut:helpUI to:1 time:0.6 hide:NO];
}
-(void)setTouchMode:(NSInteger)mode point:(CGPoint)point{
    if(mode==-1){
        [self hideHelp];
    }
}

-(void)outFun{
    NSLog(@"info outFun");
    //cacheImage=[[UIImageView alloc] initWithImage:[GlobalFunction imageFromView:self.view]];
    //[self.view addSubview:cacheImage];
    
    RemoveRelease(logoUI);
    RemoveRelease(helpUI);
    
}
- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //RemoveRelease(bgUI);
    RemoveRelease(cacheImage);
    RemoveRelease(logoUI);
    RemoveRelease(helpUI);
    [super dealloc];
    
}


@end
