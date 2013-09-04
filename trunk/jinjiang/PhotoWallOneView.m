//
//  PhotoWallOneView.m
//  jinjiang
//
//  Created by zi cheng on 11-12-23.
//  Copyright (c) 2011年 W+K. All rights reserved.
//

#import "PhotoWallOneView.h"

#import "PhotoWallOneUC.h"

#import "GlobalFunction.h"

@implementation PhotoWallOneView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isSmall=NO;
        // Initialization code
    }
    return self;
}
-(void)setUrl:(NSString *)str{
    Release2Nil(_str);
    _str=[str retain];
    self.image=nil;
    
}
-(void)showSmall{
    if(!isSmall || self.image==nil){
        isSmall=YES;
        UIImage *tem=[[UIImage alloc] initWithContentsOfFile:[PhotoWallOneUC getSmallFile:_str]];
        self.image=tem;
        [tem release];
    }
}
-(void)showBig{
    NSLog(@"showBig::::::");
    if(isSmall || self.image==nil){
        isSmall=NO;
        UIImage *tem=[[UIImage alloc] initWithContentsOfFile:_str];
        self.image=tem;
        [tem release];
    }
}
- (void)dealloc
{
    Release2Nil(_str);
    
    [super dealloc];
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
