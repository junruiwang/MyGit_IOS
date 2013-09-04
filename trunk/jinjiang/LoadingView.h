//
//  LoadingView.h
//  chengguo
//
//  Created by Jeff.Yan on 11-5-22.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingView : UIView {
    UIActivityIndicatorView *spinner;
}
-(void)start;
-(void)stop;
@end
