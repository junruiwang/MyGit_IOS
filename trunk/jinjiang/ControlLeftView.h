//
//  ControlLeftView.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-4.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ControlLeftView : UIView{
    BOOL isOut;
    CGRect _showRect;
    CGRect _hideRect;
 
}
@property (nonatomic, assign) CGRect showRect;
@property (nonatomic, assign) CGRect hideRect;

-(void)show;
-(void)hide;

@end

