//
//  LoadImageView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-9.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "LoadImageView.h"


@implementation LoadImageView
@synthesize delegate,cornerRadius;
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
}
-(void)showLoading{
    [self addSubview:spinner];
    if(imageUV.superview){
        [imageUV removeFromSuperview];
    }
    [spinner startAnimating];
}
-(void)loadImageErr{
    
}
-(void)showImageWidthData:(UIImage *)data{
    
    [spinner removeFromSuperview];
    imageUV.image=data;
    [spinner stopAnimating];
    [self addSubview:imageUV];
    //NSLog(@"alpha:::%f",imageUV.alpha);
    if(fadeIn){
        [PRTween removeTweenOperation:tween];
        Release2Nil(tween);
        tween=[[PRTween tween:imageUV property:@"alpha" from:0 to:1 duration:0.3] retain];
    }else{
        if(imageUV.alpha==0){
            
        }else{
            imageUV.alpha=1;
            [PRTween removeTweenOperation:tween];
            Release2Nil(tween);
            tween=[[PRTween tween:imageUV property:@"alpha" from:0 to:1 duration:0.3] retain];
        }
    }
    if(delegate){
        [delegate loadComplete:self];
    }
    //[data release];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        fadeIn=NO;
        
        imageUV=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        //imageV
        imageUV.contentMode = UIViewContentModeScaleToFill;
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setCenter:CGPointMake(frame.size.width/2,frame.size.height/2)]; // I do this because I'm in landscape mode
        
        //loading= [GlobalFunction getLoadingView:CGRectMake(3,3,frame.size.width-6,frame.size.height-6)];
        spinner.userInteractionEnabled=NO;
        
        imageUV.userInteractionEnabled=NO;
        
    }
    return self;
}
-(void)reSet{
    [PRTween removeTweenOperation:tween];
    Release2Nil(tween);
    if(cg!=nil){
        [cg cancel];
        Release2Nil(cg);
    }
    imageUV.image=nil;
    if(imageUV.superview){
        [imageUV removeFromSuperview];
    }
}
-(void)clear{
    [PRTween removeTweenOperation:tween];
    Release2Nil(tween);
    if(cg!=nil){
        [cg cancel];
        Release2Nil(cg);
    }
    RemoveRelease(spinner);
    RemoveRelease(imageUV);
}
-(void)loadImage:(NSString *)url fadeIn:(BOOL)fi{
    fadeIn=fi;
    [self loadImage:url];
}
-(void)loadImage:(NSString *)url{
    [self showLoading];
    [self reSet];
     imageUV.alpha=0;
    cg=[LoadImageUrlConnection initLoadImage:url onDidOk:@selector(showImageWidthData:) onErr:@selector(loadImageErr) delegate:self index:nil];
     if(!fadeIn){
         imageUV.alpha=1;
     }
}
- (void)dealloc
{
    //[self clear];
    [PRTween removeTweenOperation:tween];
    Release2Nil(tween);
    RemoveRelease(spinner);
    RemoveRelease(imageUV);
    
    [super dealloc];
}

@end
