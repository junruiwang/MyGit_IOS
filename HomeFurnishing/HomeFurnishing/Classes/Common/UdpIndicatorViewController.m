//
//  UdpIndicatorViewController.m
//  IntelligentHome
//
//  Created by jerry on 13-12-13.
//  Copyright (c) 2013年 jerry.wang. All rights reserved.
//

#import "UdpIndicatorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PulsingHaloLayer.h"

#define kMaxRadius 160

@interface UdpIndicatorViewController ()

@property (weak, nonatomic) IBOutlet UIView *indicateView;
@property (nonatomic, weak) IBOutlet UIImageView *beaconView;
@property (nonatomic, strong) PulsingHaloLayer *haloLayer;

@end

@implementation UdpIndicatorViewController

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
    
    [self loadIndicateView];
    self.haloLayer = [PulsingHaloLayer layer];
    self.haloLayer.position = self.beaconView.center;
    
    [self.indicateView.layer insertSublayer:self.haloLayer below:self.beaconView.layer];
    
	[self setupInitialValues];
}

- (void)loadIndicateView
{
    self.indicateView.layer.cornerRadius = 5;
    self.indicateView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.indicateView.layer.borderWidth = 2.0;
}

- (void)setupInitialValues {
    self.haloLayer.radius = 2 * kMaxRadius;
    UIColor *color = [UIColor colorWithRed:0 green:0.487 blue:1.0 alpha:1.0];
    self.haloLayer.backgroundColor = color.CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
