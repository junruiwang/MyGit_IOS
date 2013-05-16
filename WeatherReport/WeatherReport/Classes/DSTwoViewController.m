//
//  BannerViewController.h
//  WeatherReport
//
//  Created by jerry on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "DSTwoViewController.h"

@implementation DSTwoViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"two";
    float imageHeight = 367;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        imageHeight += 88;
    }
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imageHeight)];
    bgImageView.backgroundColor = [UIColor clearColor];
    bgImageView.image = [UIImage imageNamed:@"load_bg2.png"];
    [self.view addSubview:bgImageView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
