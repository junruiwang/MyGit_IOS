//
//  ClientAlipaySuccessViewController.m
//  JinJiangTravelPlus
//
//  Created by jerry on 13-6-3.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "ClientAlipaySuccessViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ClientAlipaySuccessViewController ()

@end

@implementation ClientAlipaySuccessViewController

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
    [self setTitle:@"支付完成"];
    [self loadBaseImageView];
    
    self.navigationItem.leftBarButtonItem= nil;
    self.navigationItem.hidesBackButton= YES;
    [self generateCompleteButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"支付宝客户端支付页面";
    [super viewWillAppear:animated];
}

- (void)loadBaseImageView
{
    float topHeight = 330;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEVICE_5]) {
        topHeight += 88;
    }
    
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, topHeight)];
    self.topImageView.backgroundColor = [UIColor clearColor];
    self.topImageView.image = [UIImage imageNamed:@"client_pay_success_bg.png"];
    [self.view addSubview:self.topImageView];
    
    self.bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topHeight, 320, 90)];
    self.bottomImageView.backgroundColor = [UIColor clearColor];
    self.bottomImageView.image = [UIImage imageNamed:@"client_pay_success_bottom.png"];
    [self.view addSubview:self.bottomImageView];
    
    self.contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 64, 260, 190)];
    self.contentImageView.backgroundColor = [UIColor clearColor];
    self.contentImageView.image = [UIImage imageNamed:@"client_pay_success_content.png"];
    [self.view addSubview:self.contentImageView];
    
    UILabel *productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 84, 56, 18)];
    productNameLabel.backgroundColor = [UIColor clearColor];
    productNameLabel.font = [UIFont systemFontOfSize:14];
    productNameLabel.textColor = [UIColor darkGrayColor];
    productNameLabel.text = @"商品名称";
    [self.contentImageView addSubview:productNameLabel];
    
    UILabel *orderNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 123, 56, 18)];
    orderNoLabel.backgroundColor = [UIColor clearColor];
    orderNoLabel.font = [UIFont systemFontOfSize:14];
    orderNoLabel.textColor = [UIColor darkGrayColor];
    orderNoLabel.text = @"订单号";
    [self.contentImageView addSubview:orderNoLabel];
    
    UILabel *payAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 163, 56, 18)];
    payAmountLabel.backgroundColor = [UIColor clearColor];
    payAmountLabel.font = [UIFont systemFontOfSize:14];
    payAmountLabel.textColor = [UIColor darkGrayColor];
    payAmountLabel.text = @"支付金额";
    [self.contentImageView addSubview:payAmountLabel];
    
    UIView *productView = [[UIView alloc] initWithFrame:CGRectMake(88, 82, 159, 21)];
    productView.backgroundColor = [UIColor clearColor];
    productView.clipsToBounds = YES;
    [self.contentImageView addSubview:productView];
    
    UILabel *productLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 159, 21)];
    productLabel.backgroundColor = [UIColor clearColor];
    productLabel.font = [UIFont systemFontOfSize:15];
    productLabel.textColor = RGBCOLOR(108, 179, 241);
    productLabel.text = self.paymentForm.hotelName;
    [productView addSubview:productLabel];
    [self setLabelAnimation:productLabel];
    
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 121, 159, 21)];
    orderLabel.backgroundColor = [UIColor clearColor];
    orderLabel.font = [UIFont systemFontOfSize:15];
    orderLabel.textColor = RGBCOLOR(108, 179, 241);
    orderLabel.text = self.paymentForm.orderNo;
    [self.contentImageView addSubview:orderLabel];
    
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 161, 159, 21)];
    amountLabel.backgroundColor = [UIColor clearColor];
    amountLabel.font = [UIFont systemFontOfSize:15];
    amountLabel.textColor = RGBCOLOR(108, 179, 241);
    amountLabel.text = [NSString stringWithFormat:@"%@元",self.paymentForm.amount];
    [self.contentImageView addSubview:amountLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLabelAnimation:(UILabel *) animationLabel
{
    [animationLabel sizeToFit];
    CGFloat width = animationLabel.frame.size.width;
    CGFloat actualWidth = 159;
    if (width > actualWidth)
    {
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
        CGFloat totalTime = (width - actualWidth)/25 + 3;
        animation.duration = totalTime;
        animation.fillMode = kCAFillModeForwards;
        
        animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:width / 2],
                            [NSNumber numberWithFloat:width / 2],
                            [NSNumber numberWithFloat:actualWidth - width / 2],
                            [NSNumber numberWithFloat:actualWidth - width / 2],
                            [NSNumber numberWithFloat:width / 2], nil];
        animation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                              [NSNumber numberWithFloat:1/totalTime],
                              [NSNumber numberWithFloat:1/totalTime + ((totalTime - 2) / (totalTime * 2))],
                              [NSNumber numberWithFloat:2/totalTime + ((totalTime - 2) / (totalTime * 2))],
                              [NSNumber numberWithFloat:1.0], nil];
        
        animation.removedOnCompletion = NO;
        animation.repeatCount = HUGE_VALF;
        [animationLabel.layer addAnimation:animation forKey:nil];
    }
}

- (void) generateCompleteButton
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"back_complete.png"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"back_complete_press.png"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(pushOrderListController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)pushOrderListController:(id) sender
{
    [self performSegueWithIdentifier:@"clientAlipaySuccessToBillList" sender:self];
}

@end
