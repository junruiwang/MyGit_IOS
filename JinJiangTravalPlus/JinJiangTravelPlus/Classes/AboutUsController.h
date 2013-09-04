//
//  AboutUsController.h
//  JinJiangTravelPlus
//
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "JJViewController.h"

@interface AboutUsController : JJViewController
{
    NSString *_title1;
    NSString *_body;

    UIImageView* whiteView;
    UIButton* rate1;
    UIButton* cret1;

    UITapGestureRecognizer* tapHide2;
    float _iOS_version;
}

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UITextView *aboutUsText;
@property(nonatomic, strong)UIImageView* coverImage;

@property(nonatomic, weak) IBOutlet UIView *contentView;
@property(nonatomic, weak) IBOutlet UIImageView *contentImageView;

- (IBAction)wantToRateButtonPressed:(id)sender;
- (IBAction)toRatePressed:(id)sender;
- (IBAction)critizePressed:(id)sender;

@end
