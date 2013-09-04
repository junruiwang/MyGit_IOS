//
//  CellButton.h
//  JinJiangTravalPlus
//
//  Created by jerry on 12-11-2.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellButton : UIButton

@property(nonatomic, strong) UIImage *leftImage;
@property(nonatomic, copy) NSString *leftText;
@property(nonatomic, strong) UILabel *leftLabel;

- (void)setTitle:(NSString *)title;

@end
