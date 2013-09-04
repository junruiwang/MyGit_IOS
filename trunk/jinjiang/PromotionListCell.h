//
//  PromotionListCell.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadImageView.h"


@interface PromotionListCell : UIView <LoadImageViewDelegate>{
    LoadImageView *imageView;
    NSDictionary *data;
    UIButton *linkBtn;
    UIButton *shareBtn;
    BOOL loaded;
}
-(void)setData:(NSDictionary *)dic isInit:(BOOL)ii;
@end
