//
//  MovPlayerView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-6.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "MovPlayerView.h"

#import "JJ360VC.h"

#import "GlobalFunction.h"
#import "MainNC.h"
#import "NavigationView.h"
#import "jinjiangViewController.h"
#import "RootWindowUI.h"

#import <MediaPlayer/MediaPlayer.h>



@implementation MovPlayerView


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hit=nil;
    hit=[super hitTest:point withEvent:event];
    if(moviePlayer!=nil && moviePlayer.fullscreen && hit!=nil){
        [GlobalFunction closeTouch];
    }
    return hit;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        //UIMoviePlayerController MPMoviePlayerViewController
        self.backgroundColor=[UIColor blackColor];
        moviePlayer=nil;
               
  
        
    }
    return self;
}
-(void)stop{
    if(moviePlayer!=nil)[moviePlayer stop];
    //Release2Nil(moviePlayer);
}
-(void)clear{
    if(moviePlayer!=nil){
        [moviePlayer stop];
        [moviePlayer.view removeFromSuperview];
    }
    Release2Nil(moviePlayer);
    [self removeFromSuperview];
}
-(void)play:(NSString *)url{
    
//    NSString *resourcePath = [ [NSBundle mainBundle] resourcePath];
//    NSString *filePath = [resourcePath stringByAppendingPathComponent:url];
    //NSLog(@"filePath:::%@",filePath);
    if(moviePlayer){
        [moviePlayer stop];
        [moviePlayer.view removeFromSuperview];
    }
    Release2Nil(moviePlayer);
    if(moviePlayer==nil){
        moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieCallback:)
                                                 name:MPMoviePlayerWillEnterFullscreenNotification
                                               object:moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieCallback:)
                                                 name:MPMoviePlayerDidEnterFullscreenNotification
                                               object:moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieCallback:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieCallback:)
                                                 name:MPMoviePlayerDidExitFullscreenNotification
                                               object:moviePlayer];
    
        [moviePlayer.view setFrame:CGRectMake(208, (768-480)/2, 640, 480)];
        
        [self addSubview:moviePlayer.view];
    }
    if(moviePlayer!=nil)[moviePlayer play];
    
}
- (void)myMovieCallback:(NSNotification*)aNotification
{
    //MPMoviePlayerController *theMovie=[aNotification object];
    //NSLog(@":::%@",aNotification.name);
    if(aNotification){
        if([aNotification.name isEqual:MPMoviePlayerDidEnterFullscreenNotification]){
            [RootWindowUI closeOpen:YES];
        }else  if([aNotification.name isEqual:MPMoviePlayerDidExitFullscreenNotification]){
            [RootWindowUI closeOpen:NO];  
        }
    }
    
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
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
    [RootWindowUI closeOpen:NO];
    if(moviePlayer!=nil)[moviePlayer.view removeFromSuperview];
    Release2Nil(moviePlayer);
    [super dealloc];
}

@end
