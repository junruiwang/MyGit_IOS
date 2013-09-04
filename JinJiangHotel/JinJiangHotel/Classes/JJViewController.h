//
//  JJViewController.h
//  JinJiang
//
//  Created by Leon on 10/23/12.
//
//

#import "Constants.h"
#import <UIKit/UIKit.h>
#import "GAI.h"
#import "LoadingIndicatorViewController.h"
#import "GDataXMLParser.h"
#import "UINavigationBar+Categories.h"
#import "UIViewController+Categories.h"
#import "UMAnalyticManager.h"
#import "DeviceInfo.h"
#import "JJNavigationBar.h"

typedef enum {
    JJCustomTypeBill = 0,
    JJCustomTypeMember = 1,
    JJCustomTypeShakeAward = 3,
    JJCustomTypeActivity = 4
} JJCustomEnumType;

@interface JJViewController : GAITrackedViewController<JJNavigationBarDelegate, UIAlertViewDelegate, GDataXMLParserDelegate, UITextFieldDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) LoadingIndicatorViewController *loadingIndicatorView;
@property (nonatomic, strong) UIControl *containerView;
@property (nonatomic, strong) JJNavigationBar *navigationBar;

- (void)showIndicatorView;
- (void)hideIndicatorView;
- (void)downloadData;

- (void) backHome: (id) sender;

- (void)call;
- (void)backToController:(Class)className;
- (void)initNavigationBarWithStyle:(JJNavigationBarStyle)barStyle;
@end