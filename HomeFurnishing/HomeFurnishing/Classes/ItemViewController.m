//
//  ItemViewController.m
//  HomeFurnishing
//
//  Created by jrwang on 14-12-13.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import "ItemViewController.h"
#import "Constants.h"

@interface ItemViewController ()

@property(nonatomic, strong) UIView *overlayView;
@property(nonatomic, strong) UIScrollView *iconView;
@property(nonatomic, strong) UIScrollView *modelsView;
@property(nonatomic, strong) NSMutableArray *btnIconList;

@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnIconList = [NSMutableArray arrayWithObjects:@"aircona.png", @"curtain.png", @"curtaina.png", @"dinner.png", @"entertainment.png", @"fitting.png", @"gym.png", @"home_arming.png", @"home_at.png", @"home_away.png", @"home_disarm.png", @"home_midnight.png", @"makeup.png", @"meeting.png", @"party.png", @"playground.png", @"pray.png", @"romance.png", @"shower.png", @"silent.png", @"sleeping_day.png", @"sleeping_night.png", @"study.png", @"summer.png", @"winter.png", nil];
    
    if (!self.overlayView)
    {
        self.overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.alpha = 0.7;
        self.overlayView.autoresizesSubviews = YES;
        self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:self.overlayView];
    }
    self.iconView = [[UIScrollView alloc] init];
    self.iconView.backgroundColor = COLOR(234,237,250);
    
    self.iconView.layer.cornerRadius = 5;
    self.iconView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.iconView.layer.borderWidth = 1.0;
    
    [self.iconView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.iconView];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:240.0f];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:00.0f];
    [self.view addConstraint:constraint];
    
    [self.iconView addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:600.0f]];
    
    [self.iconView addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:300.0f]];
    self.iconView.contentSize = CGSizeMake(600, 500);
    self.iconView.bounces = NO;
    self.iconView.directionalLockEnabled = YES;
    self.iconView.showsHorizontalScrollIndicator = NO;
    self.iconView.showsVerticalScrollIndicator = YES;
    
    
    NSInteger startX = 23;
    NSInteger startY = 20;
    NSInteger xOff = 25;
    NSInteger yOff = 25;
    for (NSInteger i=0; i < self.btnIconList.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            
        }else if (i % 6 != 0){
            startX += (72 + xOff);
        }else{
            startY += (72 + yOff);
            startX = 23;
        }
        
        btn.frame = CGRectMake(startX, startY, 72, 72);
        [btn setImage:[UIImage imageNamed:self.btnIconList[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:self.btnIconList[i]] forState:UIControlStateHighlighted];
        [self.iconView addSubview:btn];
    }
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            self.bgImageView.image = [UIImage imageNamed:@"background-Portrait.png"];
            break;
        case UIDeviceOrientationLandscapeLeft:
            self.bgImageView.image = [UIImage imageNamed:@"background-Landscape.png"];
            break;
        case UIDeviceOrientationLandscapeRight:
            self.bgImageView.image = [UIImage imageNamed:@"background-Landscape.png"];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnClicked:(id)sender
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(backButtonClicked)])
    {
        [self.delegate backButtonClicked];
    }
}

- (IBAction)saveBtnClicked:(id)sender
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(saveItemButtonClicked:)])
    {
        MyLauncherItem *item = [[MyLauncherItem alloc] initWithTitle:@"Item 1"
                                                         iPhoneImage:@"itemImage"
                                                           iPadImage:@"itemImage-iPad"
                                                              target:@"ItemViewController"
                                                         targetTitle:@"Item 1 View"
                                                           deletable:YES];
        
        [self.delegate saveItemButtonClicked:item];
    }
}

- (IBAction)deleteBtnClicked:(id)sender
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(delItemButtonClicked:)])
    {
        MyLauncherItem *item = [[MyLauncherItem alloc] initWithTitle:@"Item 1"
                                                         iPhoneImage:@"itemImage"
                                                           iPadImage:@"itemImage-iPad"
                                                              target:@"ItemViewController"
                                                         targetTitle:@"Item 1 View"
                                                           deletable:YES];
        
        [self.delegate delItemButtonClicked:item];
    }
}


#pragma mark auto Rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    switch (toInterfaceOrientation) {
        case UIDeviceOrientationPortrait:
            self.bgImageView.image = [UIImage imageNamed:@"background-Portrait.png"];
            break;
        case UIDeviceOrientationLandscapeLeft:
            self.bgImageView.image = [UIImage imageNamed:@"background-Landscape.png"];
            break;
        case UIDeviceOrientationLandscapeRight:
            self.bgImageView.image = [UIImage imageNamed:@"background-Landscape.png"];
            break;
        default:
            break;
    }
    self.overlayView.frame = self.view.frame;
}

@end
