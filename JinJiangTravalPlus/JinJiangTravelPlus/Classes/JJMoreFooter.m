//
//  JJMoreFooter.m
//  JinJiangTravelPlus
//
//  Created by Leon on 11/12/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "JJMoreFooter.h"

@implementation JJMoreFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code    
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake(60, 25, 20, 20);
        [indicator startAnimating];
        [self addSubview:indicator];

        UILabel *loadingMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 20, 200, 30)];
        loadingMoreLabel.textColor = [UIColor brownColor];
        loadingMoreLabel.backgroundColor = [UIColor clearColor];
        loadingMoreLabel.font = [UIFont boldSystemFontOfSize:20];
        loadingMoreLabel.text = NSLocalizedString(@"正在加载更多酒店...", nil);
        [self addSubview:loadingMoreLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
