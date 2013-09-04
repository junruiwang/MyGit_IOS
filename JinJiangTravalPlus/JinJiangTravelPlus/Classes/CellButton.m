//
//  CellButton.m
//  JinJiangTravalPlus
//
//  Created by jerry on 12-11-2.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import "CellButton.h"

@interface CellButton()

@property (nonatomic, strong) UIImageView *leftImageView;

@end

@implementation CellButton

@synthesize leftImage = _leftImage;
@synthesize leftLabel;
@synthesize leftText = _leftText;
@synthesize leftImageView = _leftImageView;

- (void)setLeftImage:(UIImage *)leftImage
{
    if (_leftImage != leftImage)
    {
        _leftImage = leftImage;

        self.leftImageView.image = self.leftImage;
        const unsigned int ww = self.leftImage.size.width;
        const unsigned int hh = self.leftImage.size.height;
        self.leftImageView.frame = CGRectMake(10, 18, ww, hh);
    }
}

- (void) setLeftText:(NSString *)leftText
{
    if (self.leftText != leftText)
    {
        _leftText = [leftText copy];
        self.leftLabel.text = self.leftText;
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {   [self innerInit:frame]; }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {   [self innerInit:self.frame];    }
    return self;
}

- (void)innerInit:(CGRect)frame
{
    const unsigned int ww = self.leftImage.size.width;
    const unsigned int hh = self.leftImage.size.height;
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, ww, hh)];
//  self.leftImageView.image = self.leftImage;
    [self addSubview:self.leftImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(135, 8, 100, 40)];
    label.backgroundColor = [UIColor clearColor];
    self.leftLabel = label;
    self.leftLabel.textAlignment = UITextAlignmentRight;
    self.leftLabel.text = self.leftText;
    self.leftLabel.font = [UIFont systemFontOfSize:18];
    self.leftLabel.textColor = [UIColor colorWithRed:67.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
    [self addSubview:self.leftLabel];

    UIImage *rightImage = [UIImage imageNamed:@"hotel-next.png"];
    const int xxx = (frame.size.width-rightImage.size.width - 15);
    const int yyy = (frame.size.height-28);
    const unsigned int www = rightImage.size.width;
    const unsigned int hhh = rightImage.size.height;
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xxx, yyy, www, hhh)];
    rightImageView.image = rightImage;
    [self addSubview:rightImageView];

    UIImage* img = [UIImage imageNamed:@"common_btn_press.png"];
    [self setBackgroundImage:[img stretchableImageWithLeftCapWidth:5 topCapHeight:0]
                    forState:(UIControlStateHighlighted)];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    self.leftLabel.text = title;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    self.leftLabel.textColor = color;
}

- (void)setTitle:(NSString *)title
{
    self.leftLabel.text = title;
}

@end
