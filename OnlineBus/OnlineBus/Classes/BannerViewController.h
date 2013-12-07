//
//  BannerViewController.h
//  ChoiceCourse
//
//  Created by jerry on 13-3-28.
//
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "GADBannerViewDelegate.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "JsonParser.h"
#import "SVProgressHUD.h"
#import "ValidateInputUtil.h"

@interface BannerViewController : GAITrackedViewController<GADBannerViewDelegate, JsonParserDelegate>

@property(nonatomic, strong) GADBannerView *adBanner;
@property(nonatomic, strong) UIButton *admobCloseBtn;

- (void)loadCustomBanner;
- (GADRequest *)createRequest;
- (UIButton *)generateNavButton:(NSString *) imageName action:(SEL) actionName;
- (void)backButtonClicked:(id)sender;
- (void)showAlertMessage:(NSString *)msg;
- (void)showAlertMessageWithOkCancelButton:(NSString *)msg tag:(NSInteger)tag delegate:(id)delegate;
- (void)showAlertMessage:(NSString *)msg dismissAfterDelay:(NSTimeInterval)delay;
- (void)addRightBarButton:(UIButton *) button;

@end
