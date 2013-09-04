//
//  MenuItemVW.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuItemDelegate;

@interface MenuItemVW : UIView{
    UIImageView *imageView;
    UIImageView *bgView;
}

+ (NSMutableArray *)getIndexArray;
+(void)releaseIndexArray;

+ (id)initWithIndex:(NSInteger)index;
- (id)initWithFrame:(CGRect)frame index:(NSInteger)index;
- (void)cubeMoveOut:(NSString*) ii;
@property (nonatomic, assign) id <MenuItemDelegate> menuItemDelegate;
@end
@protocol MenuItemDelegate
- (void)select:(NSInteger)index;

@end
