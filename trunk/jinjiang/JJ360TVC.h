//
//  JJ360TVC.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-14.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalFunction.h"

@interface JJ360TVC : LeftViewCell<JJFileDownloadDelegate> {
    UILabel *titleTxt;
    UILabel *pauseTxt;
    UIView *txtBg;
    UIProgressView *_progressView;
    UIImageView *_ui;
}

@end
