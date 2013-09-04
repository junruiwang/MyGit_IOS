//
//  InfoItemView.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoItemView : UIControl {
    UIImageView *imageView;
    UIView *bgView;
    NSInteger _index;
}
- (id)initWithFrame:(CGRect)frame index:(NSInteger)index;
- (void)cubeMoveOut;
-(void)cubeMoveIn;
@end
