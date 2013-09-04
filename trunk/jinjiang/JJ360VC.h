//
//  JJ360VC.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJUIViewController.h"
#import "LeftViewCell.h"
#import "LeftScrollView.h"
#import "HTTPConnection.h"
#import "JJ360.h"
#import "JJMovie.h"

@class JJ360View,MovPlayerView,LeftScrollView,LeftScrollViewDelegate;

@interface JJ360VC:JJUIViewController <LeftScrollViewDelegate, JJFileDownloadDelegate, HTTPConnectionDelegate>{
    JJ360View *jj360View;
    MovPlayerView *movPlayView;
    LeftScrollView *t3dLeft;
    LeftScrollView *movLeft;
    NSInteger index;
    HTTPConnection *_360_hTTPConnection;
    HTTPConnection *_mov_hTTPConnection;
}

- (void)get360s;
- (void)getMovies;

@end
