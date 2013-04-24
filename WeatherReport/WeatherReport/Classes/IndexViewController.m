//
//  IndexViewController.m
//  WeatherReport
//
//  Created by jerry on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "IndexViewController.h"

@interface IndexViewController ()

@property(nonatomic, strong) UIImageView *bgImageView;

@end

@implementation IndexViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self loadBgImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadBgImageView
{
    self.bgImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.autoresizesSubviews=YES;
    self.bgImageView.opaque=YES;
    self.bgImageView.clearsContextBeforeDrawing=YES;
    self.bgImageView.image = [UIImage imageNamed:@"bg_wtx.jpg"];
    [self.view addSubview:self.bgImageView];
}

@end
