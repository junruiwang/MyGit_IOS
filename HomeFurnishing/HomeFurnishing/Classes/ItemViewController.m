//
//  ItemViewController.m
//  HomeFurnishing
//
//  Created by jrwang on 14-12-13.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import "ItemViewController.h"
#import "Constants.h"

#define ICON_IMAGE_TAG  100

@interface ItemViewController ()

@property(nonatomic, strong) UIView *overlayView;
@property(nonatomic, strong) UIView *imagePageView;
@property(nonatomic, strong) UIScrollView *iconView;
@property(nonatomic, strong) UIScrollView *modelsView;
@property(nonatomic, strong) NSMutableArray *btnIconList;
@property(nonatomic, strong) UIImageView *tapImageView;

@property(nonatomic, strong) NSString *imageNameStr;

@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnIconList = [NSMutableArray arrayWithObjects:@"aircona.png", @"curtain.png", @"curtaina.png", @"dinner.png", @"entertainment.png", @"fitting.png", @"gym.png", @"home_arming.png", @"home_at.png", @"home_away.png", @"home_disarm.png", @"home_midnight.png", @"makeup.png", @"meeting.png", @"party.png", @"playground.png", @"pray.png", @"romance.png", @"shower.png", @"silent.png", @"sleeping_day.png", @"sleeping_night.png", @"study.png", @"summer.png", @"winter.png", nil];
    
    [self loadPopImageView];
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

- (void)iconButtonClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tagIndex = btn.tag;
    self.imageNameStr = self.btnIconList[tagIndex - ICON_IMAGE_TAG];
    self.tapImageView.center = btn.center;
}

- (void)submitButtonClicked:(id)sender
{
    if (self.imageNameStr) {
        [self.imageBtn setImage:[UIImage imageNamed:self.imageNameStr] forState:UIControlStateNormal];
        [self.imageBtn setImage:[UIImage imageNamed:self.imageNameStr] forState:UIControlStateHighlighted];
    }
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.overlayView.alpha = 0;
                         self.imagePageView.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
                     }
                     completion:^(BOOL finished){
                         self.imagePageView.hidden = YES;
                         self.imagePageView.transform = CGAffineTransformIdentity;
                     }];
}

- (void)cancelButtonClicked:(id)sender
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.overlayView.alpha = 0;
                         self.imagePageView.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
                     }
                     completion:^(BOOL finished){
                         self.imagePageView.hidden = YES;
                         self.imagePageView.transform = CGAffineTransformIdentity;
                     }];
}

- (IBAction)imageButtonClicked:(id)sender
{
    self.imagePageView.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
    self.imagePageView.hidden = NO;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.overlayView.alpha = 0.7;
                         self.imagePageView.transform = CGAffineTransformIdentity;
                     }
                     completion:NULL];
    
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


- (void)loadPopImageView
{
    //添加遮罩层
    if (!self.overlayView)
    {
        self.overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.alpha = 0;
        self.overlayView.autoresizesSubviews = YES;
        self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:self.overlayView];
    }
    //添加imagePageView视图
    self.imagePageView = [[UIView alloc] init];
    self.imagePageView.backgroundColor = COLOR(234,237,250);
    self.imagePageView.layer.cornerRadius = 5;
    self.imagePageView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.imagePageView.layer.borderWidth = 1.0;
    [self.imagePageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.imagePageView];
    //imagePageView添加约束
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.imagePageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:200.0f];
    [self.view addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self.imagePageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:00.0f];
    [self.view addConstraint:constraint];
    [self.imagePageView addConstraint:[NSLayoutConstraint constraintWithItem:self.imagePageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:600.0f]];
    [self.imagePageView addConstraint:[NSLayoutConstraint constraintWithItem:self.imagePageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:450.0f]];
    
    UILabel *selIcon = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
    selIcon.backgroundColor = [UIColor clearColor];
    selIcon.text = @"选择图标";
    selIcon.textColor = COLOR(134,210,235);
    selIcon.font = [UIFont systemFontOfSize:20];
    [self.imagePageView addSubview:selIcon];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 600, 1)];
    line.backgroundColor = COLOR(134,210,235);
    [self.imagePageView addSubview:line];
    
    //添加iconView到imagePageView 并添加约束
    self.iconView = [[UIScrollView alloc] init];
    self.iconView.backgroundColor = [UIColor clearColor];
    
    [self.iconView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.imagePageView addSubview:self.iconView];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imagePageView attribute:NSLayoutAttributeTop multiplier:1.0f constant:60.0f];
    [self.imagePageView addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imagePageView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:00.0f];
    [self.imagePageView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.imagePageView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:00.0f];
    [self.imagePageView addConstraint:constraint];
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
        btn.tag = ICON_IMAGE_TAG + i;
        btn.frame = CGRectMake(startX, startY, 72, 72);
        [btn setImage:[UIImage imageNamed:self.btnIconList[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:self.btnIconList[i]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(iconButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.iconView addSubview:btn];
    }
    UIImageView *lineBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 380, 600, 1)];
    lineBottom.backgroundColor = COLOR(134,210,235);
    [self.imagePageView addSubview:lineBottom];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(240, 400, 56, 30);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"book.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.imagePageView addSubview:submitBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(340, 400, 56, 30);
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"book.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.imagePageView addSubview:cancelBtn];
    
    self.tapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 100, 100)];
    self.tapImageView.image = [UIImage imageNamed:@"icon_selected"];
    [self.iconView addSubview:self.tapImageView];
    
    self.imagePageView.hidden = YES;
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
