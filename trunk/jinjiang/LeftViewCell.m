//
//  LeftViewCell.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-14.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "LeftViewCell.h"
#import "GlobalFunction.h"


@implementation LeftViewCell

@synthesize delegate;

-(void)cellClicked{
    // NSLog(@"cellClicked:");
    
    [self selectEd:YES a:YES];
}
-(void)selectFun:(BOOL)b  a:(BOOL)a{
    
}
-(void)selectEd:(BOOL)b{
    [self selectEd:b a:NO];
}
-(void)selectEd:(BOOL)b a:(BOOL)a{
    //NSLog(@"selectEd::::::::::%@:::%d",delegate,self.tag);
    if(b){
        if(delegate!=nil){
            [delegate selectView:self];
        }
        [self selectFun:YES a:YES];
    }else{
        [self selectFun:NO a:YES];
    }
}
-(void)setData:(id)d index:(NSInteger)si
{
    RemoveRelease(overView);
    RemoveRelease(outView);
    if(si==self.tag){
        [self selectFun:YES a:NO];
    }else{
        [self selectFun:NO a:NO];
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        delegate=nil;
        overView=nil;
        outView=nil;
        //NSLog(@"initWithFrame:");
        [self addTarget:self action:@selector(cellClicked) forControlEvents:UIControlEventTouchUpInside];
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

- (void)dealloc
{
    NSLog(@"leftViewCell dealloc");
    
    RemoveRelease(overView);
    RemoveRelease(outView);
    [super dealloc];
}

@end
