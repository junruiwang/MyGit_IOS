//
//  PromotionVC.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJUIViewController.h"
#import "ControlView.h"
#import "PromotionListCell.h"

@interface PromotionVC : JJUIViewController <UIScrollViewDelegate, HTTPConnectionDelegate> {
    UIScrollView *scrView;

    NSArray *data;
    
    HTTPConnection *hTTPConnection;
    
    NSMutableArray *viewList;
    
    
    BOOL isDown;

}

@end
