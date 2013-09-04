//
//  JYScrollView.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-28.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYScrollViewDelegate;

@interface JYScrollView : UIView {
    UIView *contentView;
    CGPoint _contentOffset;
    id<JYScrollViewDelegate> delegate;
    CGSize contentSize;
}
@property(nonatomic,assign) id<JYScrollViewDelegate> delegate;
@property(nonatomic,assign) CGPoint contentOffset;
@property(nonatomic,assign) CGSize contentSize;
@property(nonatomic,readonly) UIView *contentView;
- (void)setOffset:(CGPoint)contentOffset;

@end



@protocol JYScrollViewDelegate
- (void)scrollViewDidScroll:(JYScrollView *)scrollView;
@end
