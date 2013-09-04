//
//  LoadingView.m
//  chengguo
//
//  Created by Jeff.Yan on 11-5-22.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "LoadingView.h"


@implementation LoadingView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
       // UIView *bgView=[[UIView alloc] initWithFrame:frame];
        
        //bgView.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3];
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setCenter:CGPointMake(frame.size.width/2.0, frame.size.height/2.0)]; // I do this because I'm in landscape mode
        
         //[self addSubview:bgView];
        
        [self addSubview:spinner];
        spinner.userInteractionEnabled=NO;
        self.userInteractionEnabled=NO;
    
    }
    return self;
}


-(void)start{
     [spinner startAnimating];
}
-(void)stop{
    [spinner stopAnimating];
}

- (void)dealloc
{
    [spinner stopAnimating];
    [spinner release];
    [super dealloc];
}

@end
