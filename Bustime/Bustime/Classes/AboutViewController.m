//
//  AboutViewController.m
//  Bustime
//
//  Created by 汪君瑞 on 13-4-16.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    self.view.backgroundColor = RGBCOLOR(0, 133, 197);
    self.trackedViewName = @"关于软件页面";
	self.navigationItem.title = @"关于软件";
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 100)];
    imageView.image = [UIImage imageNamed:@"about_logo.png"];
    [self.view addSubview:imageView];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showWeibo:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/u/2248196321"]];
}

@end
