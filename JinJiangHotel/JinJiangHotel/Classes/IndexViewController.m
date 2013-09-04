//
//  IndexViewController.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-13.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//
#define TAG_HOTEL_SEARCH        112
#define TAG_PERSONAL_CENTER     113
#define TAG_FEED_BACK           123
#define TAG_CONFIG              130
#define TAG_FAVERATE_HOTEL      133
#define TAG_PROMOTION           141
#define TAG_ABOUT_US            142


#import "IndexViewController.h"


@interface IndexViewController ()

@end

@implementation IndexViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"%f", [DeviceInfo currentMemoryUsage]);
    
    if (self.view.frame.size.height > 500) {
        self.logoBGView.image = [UIImage imageNamed:@"logo_bg_5.png"];
        self.indexBGView.image = [UIImage imageNamed:@"index_bg_5.png"];
    } else {
        self.logoBGView.image = [UIImage imageNamed:@"logo_bg_4.png"];
        self.indexBGView.image = [UIImage imageNamed:@"index_bg_4.png"];
    }
    
    [self.indexScrollView setContentSize:CGSizeMake(320, 560)];
    
    for (UIView *subView in self.indexScrollView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            
            switch (subView.tag) {
                case TAG_HOTEL_SEARCH:
                    [((UIButton *)subView) setImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
                    break;
                case TAG_PERSONAL_CENTER:
                    [((UIButton *)subView) setImage:[UIImage imageNamed:@"icon_personal_center.png"] forState:UIControlStateNormal];
                    break;
                case TAG_FEED_BACK:
                    [((UIButton *)subView) setImage:[UIImage imageNamed:@"icon_feedback.png"] forState:UIControlStateNormal];
                    break;
                case TAG_CONFIG:
                    [((UIButton *)subView) setImage:[UIImage imageNamed:@"icon_config.png"] forState:UIControlStateNormal];
                    break;
                case TAG_FAVERATE_HOTEL:
                    [((UIButton *)subView) setImage:[UIImage imageNamed:@"icon_faverate_hotel.png"] forState:UIControlStateNormal];
                    break;
                case TAG_PROMOTION:
                    [((UIButton *)subView) setImage:[UIImage imageNamed:@"icon_promotion.png"] forState:UIControlStateNormal];
                    break;
                case TAG_ABOUT_US:
                    [((UIButton *)subView) setImage:[UIImage imageNamed:@"icon_about_us.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    self.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.navigationBar.hidden = NO;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)indexButtonPressed:(UIButton *)sender {
    switch (sender.tag) {
        case TAG_HOTEL_SEARCH:
        {
            [self performSegueWithIdentifier:FROM_INDEX_TO_SEARCH sender:self];
        }
            break;
        case TAG_PERSONAL_CENTER:
        {
            [self performSegueWithIdentifier:FROM_INDEX_TO_PERSONAL_CENTER sender:self];
        }
            break;
        case TAG_PROMOTION:
        {
            [self performSegueWithIdentifier:FROM_INDEX_TO_PROMOTION sender:self];
        }
            break;
        case TAG_FEED_BACK:
        {
            [self performSegueWithIdentifier:FROM_INDEX_TO_FEEDBACK sender:self];
        }
            break;
        case TAG_ABOUT_US:
        {
            [self performSegueWithIdentifier:FROM_INDEX_TO_ABOUT sender:self];
        }
            break;
            
        default:
            break;
    }
}

- (int)getTagByRow:(int)row andColumn:(int)column
{
    return 100 + row * 10 + column;
}

- (void)viewDidUnload {
    [self setIndexScrollView:nil];
    [self setLogoBGView:nil];
    [self setIndexBGView:nil];
    [super viewDidUnload];
}
@end
