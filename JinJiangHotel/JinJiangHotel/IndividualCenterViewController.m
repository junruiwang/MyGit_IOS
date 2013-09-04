//
//  IndividualCenterViewController.m
//  JinJiangHotel
//
//  Created by 杨 栋栋 on 13-8-22.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "IndividualCenterViewController.h"

@interface IndividualCenterViewController ()

@end

@implementation IndividualCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationBar.mainLabel.text = NSLocalizedStringFromTable(@"individual_center", @"MemberCenter", @"");

    self.selfContainerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"individual_center_index_bg.png"]];
    
    if ([[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height > 500)
    {
        self.selfContainerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"individual_center_index_ip5_bg.png"]];
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y + 60, self.contentView.frame.size.width, self.contentView.frame.size.height);
        self.selfBodyView.frame = CGRectMake(self.selfBodyView.frame.origin.x, self.selfBodyView.frame.origin.y + 60, self.selfBodyView.frame.size.width, self.selfBodyView.frame.size.height);
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
