//
//  jinjiangViewController.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-26.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalFunction.h"
#import "VersionHandle.h"

@interface jinjiangViewController : UIViewController <MFMailComposeViewControllerDelegate>{
    UIViewController *parentVC;
}
+(id)sharedInstance;
+(void)shareRelease;


- (void)modalUV:(UIViewController *)uv;
- (void)dismissUV;

+(void)modalUV:(UIViewController *)uv;
+(void)dismissUV;
+(void)toLink:(NSString *)url;

-(void)showShare:(NSInteger)index;
+(void)showShare:(NSInteger)index;

-(void)showLeaderView;
+(void)showLeaderView;

-(void)emailSend:(NSString *)title content:(NSString *)content path:(NSString *)path;
+(void)emailSend:(NSString *)title content:(NSString *)content path:(NSString *)path;

-(void)emailSend:(NSString *)email;
+(void)emailSend:(NSString *)email;
@end
