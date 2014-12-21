//
//  ItemViewController.m
//  HomeFurnishing
//
//  Created by jrwang on 14-12-13.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import "ItemViewController.h"

@interface ItemViewController ()


@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadIndicateView];
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
}

@end
