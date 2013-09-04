//
//  AboutUsViewController.h
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-13.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJViewController.h"

@interface AboutUsViewController : JJViewController

@property (weak, nonatomic) IBOutlet UILabel *groupTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *groupDetailText;

@property (weak, nonatomic) IBOutlet UITextView *brandDetailText;
@property (weak, nonatomic) IBOutlet UILabel *brandTitleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *textScrollView;
@end
