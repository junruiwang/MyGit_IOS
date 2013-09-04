//
//  MainNC.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJUIViewController.h"
#import "JJ360VC.h"
#import "ClubVC.h"

@class LoadingView;

@interface MainNC : UINavigationController{
    //CGMutablePathRef Path;
    JJUIViewController *cutVC;
    NSInteger pageIndex;
    ClubVC *_clubVC;
    JJ360VC *_jj360VC;
}
//@property  (nonatomic, retain) JJUIViewController *cutVC;
+ (id)sharedInstance;
+ (void)shareRelease;

+(void)toShowPage:(NSInteger)index mode:(NSInteger)mode;
-(void)toShowPage:(NSInteger)index mode:(NSInteger)mode;

+(void)checkDelayMode:(NSInteger)mode;
+(void)checkPaths:(NSMutableDictionary *)nd;
-(void)checkPaths:(NSMutableDictionary *)nd;


@end
