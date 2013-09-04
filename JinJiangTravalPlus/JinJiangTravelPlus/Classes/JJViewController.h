//
//  JJViewController.h
//  JinJiang
//
//  Created by Leon on 10/23/12.
//
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "LoadingIndicatorViewController.h"
#import "GDataXMLParser.h"
#import "UINavigationBar+Categories.h"
#import "UIViewController+Categories.h"
#import "UMAnalyticManager.h"
#import "Constants.h"

@interface JJViewController : GAITrackedViewController<UIAlertViewDelegate, GDataXMLParserDelegate, UITextFieldDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) LoadingIndicatorViewController *loadingIndicatorView;
@property (nonatomic, strong) UIControl *containerView;

- (void)showIndicatorView;
- (void)hideIndicatorView;
- (void)downloadData;
- (void)addLeftBarButton:(NSString *) imageName;
- (void)addRightBarButton;

- (UIButton *)generateNavButton:(NSString *) imageName action:(SEL) actionName;
- (void) backHome: (id) sender;

- (void)call;
- (void)backToController:(Class)className;
@end