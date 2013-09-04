//
//  PhotoWallOneUC.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-22.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PRTween.h"
@protocol PhotoWallOneUCDelegate;
@interface PhotoWallOneUC : UIControl {
    UIImageView *imageView;
    UIView *outView;
    UIView *overView;
    NSInteger _index;
    id <PhotoWallOneUCDelegate> delegate;
    
    //PRTweenOperation *overTween;
    //PRTweenOperation *outTween;
    
}
//
@property (nonatomic, assign) id <PhotoWallOneUCDelegate> delegate;
@property (nonatomic, assign)NSInteger index;
+(void)selectIndex:(NSInteger)i;
+(NSInteger)selectIndex;
+(NSString *)getSmallFile:(NSString *)str;
-(void)setData:(NSString *)dic index:(NSInteger)index;
-(void)selectEd:(BOOL)b;
@end
@protocol PhotoWallOneUCDelegate
-(void)selectPo:(NSInteger)index;


@end