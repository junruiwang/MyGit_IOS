//
//  ShareView.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-9.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WBConnect.h"
#import "ModalWebVC.h"

@interface ShareView : UIControl <WBSessionDelegate,WBSendViewDelegate,WBRequestDelegate,ModalWebVCDelegate,UITextViewDelegate>{
     WeiBo* weibo;
    UIView *btnsView;
    UIView *shareView;
    UITextView *shareTxt;
    UITextView *cutTxt;
    NSInteger showIndex;
    NSInteger dataIndex;
}
- (id)initWithFrame:(CGRect)frame withData:(NSInteger)index;
@end
