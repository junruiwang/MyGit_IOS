//
//  NavigationView.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NavigationView : UIView {
    NSMutableArray *btns;
    NSInteger pageIndex;
    UIButton *tabbarBtn01;
    UIButton *tabbarBtn02;
    UIButton *tabbarBtn03;
    UIButton *tabbarBtn04;
    UIButton *tabbarBtn05;
    UIButton *tabbarBtn06;
    UIButton *tabbarBtn07;
    
    BOOL isOff;
    BOOL isShow;
}
@property  (nonatomic,assign)BOOL isShow;
@property  (nonatomic,assign)BOOL isOff;
-(void)select:(NSInteger) index mode:(NSInteger)mode;
+(void)select:(NSInteger) index mode:(NSInteger)mode;

+ (id)sharedInstance;
+ (void)shareRelease;

+ (void)showHide:(BOOL)b;
+ (void)show2Hide;
+ (void)off2Out;
+ (void)offOut:(BOOL)b;
+ (void)showHide:(BOOL)b m:(BOOL)m;
+ (void)offOut:(BOOL)b m:(BOOL)m;
+ (void)showHide:(BOOL)b autoHide:(BOOL)autoHide;

-(void)reSetList:(NSArray *)arr;
+ (void)reSetList:(NSArray *)arr;

@end
