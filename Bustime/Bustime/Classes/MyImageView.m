//
//  MyImageView.m
//  Bustime
//
//  Created by 汪君瑞 on 13-3-31.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import "MyImageView.h"
#import "IndexViewController.h"

@implementation MyImageView

- (id)initWithImage:(UIImage *)image text:(NSString *)text
{
    self = [super init];
    if (self)
    {
        UIImageView *imagview= [[UIImageView alloc]initWithImage:image];
        imagview.frame = CGRectMake(0,0,120,120);
        [self addSubview:imagview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0,120,120,20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:20];
        label.text = text;
        label.textColor = [UIColor blackColor];
        label.textAlignment = UITextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}

-(void)setdege:(id)ID
{
	self.userInteractionEnabled = YES;
	dege = ID;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	IndexViewController *tmp = (IndexViewController *)dege;
	[tmp clickUp:self.tag];
}

@end
