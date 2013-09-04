//
//  PhotoWallOneView.h
//  jinjiang
//
//  Created by zi cheng on 11-12-23.
//  Copyright (c) 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoWallOneView : UIImageView{
    BOOL isSmall;
    NSString *_str;
}
-(void)showSmall;
-(void)showBig;
-(void)setUrl:(NSString *)str;
@end
