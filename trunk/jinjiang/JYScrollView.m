//
//  JYScrollView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-28.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "JYScrollView.h"


@implementation JYScrollView

@synthesize delegate,contentSize,contentOffset=_contentOffset,contentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentOffset=CGPointMake(0, 0);
        contentView=[[UIView alloc] initWithFrame:FULLRECT];
        //contentView.backgroundColor=[UIColor redColor];
        [super addSubview:contentView];
        // Initialization code
    }
    return self;
}
-(CGPoint)getContentOffset{
    return _contentOffset;
}
- (void)setOffset:(CGPoint)contentOffset{
    _contentOffset.x=contentOffset.x;
    _contentOffset.y=contentOffset.y;
    CGRect rect=contentView.frame;
    rect.origin.x=-_contentOffset.x;
    rect.origin.y=-_contentOffset.y;
    contentView.frame=rect;
}
- (void)setContentOffset:(CGPoint)contentOffset{
    [self setOffset:contentOffset];
    if(delegate){
        [delegate scrollViewDidScroll:self];
    }
}
-(void)addSubview:(UIView *)view{
    [contentView addSubview:view];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    RemoveRelease(contentView);
    [super dealloc];
}

@end
