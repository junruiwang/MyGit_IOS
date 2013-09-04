//
//  MovPlayerView.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-6.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPMoviePlayerController;

@interface MovPlayerView : UIView {
    MPMoviePlayerController *moviePlayer;
}
-(void)stop;
-(void)play:(NSString *)url;
-(void)clear;
@end
