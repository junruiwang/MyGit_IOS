//
//  AnnInfoView.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-9.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JJMKAnnotationView,LoadImageView;

@interface AnnInfoView : UIView {
    NSDictionary *data;
    JJMKAnnotationView *annView;
    LoadImageView *loadImage;
    //UIButton *but;
    //UICalloutView
}
-(void)removeOut;
- (id)initWithDic:(NSDictionary *)dic;
@end
