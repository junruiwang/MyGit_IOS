//
//  SettingIndexViewController.m
//  HomeFurnishing
//
//  Created by jrwang on 14-12-13.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import "SettingIndexViewController.h"
#import "SceneModeViewController.h"
#import "LoginViewController.h"
#import "MyLauncherView.h"
#import "MyLauncherItem.h"
#import "BaseNavigationController.h"
#import "ItemViewController.h"
#import "Constants.h"

@interface SettingIndexViewController ()<MyLauncherViewDelegate>

@property (nonatomic, strong) MyLauncherView *launcherView;
@property (nonatomic, strong) BaseNavigationController *launcherNavigationController;
@property (nonatomic, strong) NSMutableDictionary *appControllers;
@property (nonatomic, strong) UIView *overlayView;

-(BOOL)hasSavedLauncherItems;
-(void)clearSavedLauncherItems;

-(void)launcherViewItemSelected:(MyLauncherItem*)item;
-(void)closeView;

-(NSMutableArray *)savedLauncherItems;
-(NSArray*)retrieveFromUserDefaults:(NSString *)key;
-(void)saveToUserDefaults:(id)object key:(NSString *)key;

@end

@implementation SettingIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetLauncherView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            self.bgImageView.image = [UIImage imageNamed:@"background-Portrait.png"];
            break;
        case UIDeviceOrientationLandscapeLeft:
            self.bgImageView.image = [UIImage imageNamed:@"background-Landscape.png"];
            break;
        case UIDeviceOrientationLandscapeRight:
            self.bgImageView.image = [UIImage imageNamed:@"background-Landscape.png"];
            break;
        default:
            break;
    }
    //绘制launcherView
    [self.launcherView viewDidAppear:animated];
}

-(void)resetLauncherView
{
    //移除launcherView
    if (self.launcherView) {
        [self.launcherView removeFromSuperview];
        self.launcherView.delegate = nil;
        self.launcherView = nil;
    }
    //重新绘制launcherView
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            self.launcherView = [[MyLauncherView alloc] initWithFrame:CGRectMake(0, 0, self.mainLauncherView.frame.size.width, self.mainLauncherView.frame.size.height)];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            self.launcherView = [[MyLauncherView alloc] initWithFrame:CGRectMake(0, 0, self.mainLauncherView.frame.size.width, self.mainLauncherView.frame.size.height)];
            break;
        case UIDeviceOrientationLandscapeLeft:
            self.launcherView = [[MyLauncherView alloc] initWithFrame:CGRectMake(0, 0, 1024, 594)];
            break;
        case UIDeviceOrientationLandscapeRight:
            self.launcherView = [[MyLauncherView alloc] initWithFrame:CGRectMake(0, 0, 1024, 594)];
            break;
        default:
            break;
    }
//    [self.launcherView setBackgroundColor:COLOR(234,237,250)];
    self.launcherView.backgroundColor = [UIColor clearColor];
    [self.launcherView setDelegate:self];
    [self.mainLauncherView addSubview:self.launcherView];
    
    [self.launcherView setPages:[self savedLauncherItems]];
    [self.launcherView setNumberOfImmovableItems:[(NSNumber *)[self retrieveFromUserDefaults:@"myLauncherViewImmovable"] intValue]];
    
    self.appControllers = [[NSMutableDictionary alloc] init];
    // Do any additional setup after loading the view.
    
    [self.appControllers setObject:[ItemViewController class] forKey:@"ItemViewController"];
    
    //Add your view controllers here to be picked up by the launcher; remember to import them above
    //[[self appControllers] setObject:[MyCustomViewController class] forKey:@"MyCustomViewController"];
    //[[self appControllers] setObject:[MyOtherCustomViewController class] forKey:@"MyOtherCustomViewController"];
    
    if(![self hasSavedLauncherItems])
    {
        [self.launcherView setPages:[NSMutableArray arrayWithObjects:
                                     [NSMutableArray arrayWithObjects:
                                      [[MyLauncherItem alloc] initWithTitle:@"Item 1"
                                                                iPhoneImage:@"itemImage"
                                                                  iPadImage:@"itemImage-iPad"
                                                                     target:@"ItemViewController"
                                                                targetTitle:@"Item 1 View"
                                                                  deletable:YES],
                                      [[MyLauncherItem alloc] initWithTitle:@"Item 2"
                                                                iPhoneImage:@"itemImage"
                                                                  iPadImage:@"itemImage-iPad"
                                                                     target:@"ItemViewController"
                                                                targetTitle:@"Item 2 View"
                                                                  deletable:YES],
                                      [[MyLauncherItem alloc] initWithTitle:@"Item 3"
                                                                iPhoneImage:@"itemImage"
                                                                  iPadImage:@"itemImage-iPad"
                                                                     target:@"ItemViewController"
                                                                targetTitle:@"Item 3 View"
                                                                  deletable:YES],
                                      [[MyLauncherItem alloc] initWithTitle:@"Item 4"
                                                                iPhoneImage:@"addItemImage"
                                                                  iPadImage:@"addItemImage-iPad"
                                                                     target:@"ItemViewController"
                                                                targetTitle:@"Item 4 View"
                                                                  deletable:YES],
                                      nil],
                                     nil]];
        
        // Set number of immovable items below; only set it when you are setting the pages as the
        // user may still be able to delete these items and setting this then will cause movable
        // items to become immovable.
//         [self.launcherView setNumberOfImmovableItems:1];
        
        // Or uncomment the line below to disable editing (moving/deleting) completely!
        // [self.launcherView setEditingAllowed:NO];
    }
    
    // Set badge text for a MyLauncherItem using it's setBadgeText: method
//    [(MyLauncherItem *)[[[self.launcherView pages] objectAtIndex:0] objectAtIndex:0] setBadgeText:@"4"];
}

-(IBAction)loginoutButtonClicked:(id)sender
{
    BOOL isExist = NO;
    UIViewController *loginViewController = nil;
    NSArray *controllers = [self.navigationController viewControllers];
    for (UIViewController *viewCtrl in controllers) {
        if ([viewCtrl isKindOfClass:[LoginViewController class]]) {
            loginViewController = viewCtrl;
            isExist = YES;
            break;
        }
    }
    if (isExist) {
        [self backTotargetController:loginViewController];
    } else {
        [self performSegueWithIdentifier:@"fromSettingToLogin" sender:nil];
    }
}

-(IBAction)backHome:(id)sender
{
    [self backToRootController];
}

#pragma mark auto Rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    switch (toInterfaceOrientation) {
        case UIDeviceOrientationPortrait:
            self.bgImageView.image = [UIImage imageNamed:@"background-Portrait.png"];
            break;
        case UIDeviceOrientationLandscapeLeft:
            self.bgImageView.image = [UIImage imageNamed:@"background-Landscape.png"];
            break;
        case UIDeviceOrientationLandscapeRight:
            self.bgImageView.image = [UIImage imageNamed:@"background-Landscape.png"];
            break;
        default:
            break;
    }
    [self resetLauncherView];
}

#pragma mark - MyLauncherItem management

-(BOOL)hasSavedLauncherItems {
    return ([self retrieveFromUserDefaults:@"myLauncherView"] != nil);
}

-(void)launcherViewItemSelected:(MyLauncherItem*)item {
    if (![self appControllers] || [self launcherNavigationController]) {
        return;
    }
    Class viewCtrClass = [self.appControllers objectForKey:[item controllerStr]];
    UIViewController *controller = [[viewCtrClass alloc] init];
    
    self.launcherNavigationController = [[BaseNavigationController alloc] initWithRootViewController:controller];
    [[self.launcherNavigationController topViewController] setTitle:item.controllerTitle];
    self.launcherNavigationController.view.frame = CGRectMake(100, 100, 500, 600);
    
//    [controller.navigationItem setLeftBarButtonItem:
//     [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"launcher"]
//                                      style:UIBarButtonItemStyleBordered
//                                     target:self
//                                     action:@selector(closeView)]];
				
    UIView *viewToLaunch = [[self.launcherNavigationController topViewController] view];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(100, 200, 56, 30);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"book.png"] forState:UIControlStateNormal];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [viewToLaunch addSubview:closeBtn];
    
    
    [self.parentViewController.view addSubview:[self.launcherNavigationController view]];
    viewToLaunch.alpha = 0;
    viewToLaunch.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
    
    if (!self.overlayView)
    {
        self.overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.alpha = 0;
        self.overlayView.autoresizesSubviews = YES;
        self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:self.overlayView];
    }
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         viewToLaunch.alpha = 1.0;
                         viewToLaunch.transform = CGAffineTransformIdentity;
                         self.overlayView.alpha = 0.7;
                     }
                     completion:nil];
}

-(void)launcherViewDidBeginEditing:(id)sender {
    [self.doneButton addTarget:self.launcherView action:@selector(endEditing) forControlEvents:UIControlEventTouchUpInside];
    self.doneButton.hidden = NO;
}

-(void)launcherViewDidEndEditing:(id)sender {
    [self.doneButton removeTarget:self.launcherView action:@selector(endEditing) forControlEvents:UIControlEventTouchUpInside];
    self.doneButton.hidden = YES;
}

- (void)closeView {
    UIView *viewToClose = [[self.launcherNavigationController topViewController] view];
    if (!viewToClose)
        return;
    
    viewToClose.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         viewToClose.alpha = 0;
                         viewToClose.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
                         self.overlayView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [[self.launcherNavigationController view] removeFromSuperview];
                         [self.launcherNavigationController setDelegate:nil];
                         [self setLauncherNavigationController:nil];
                         [self.parentViewController viewWillAppear:NO];
                         [self.parentViewController viewDidAppear:NO];
                     }];
}

#pragma mark - myLauncher caching

-(NSMutableArray *)savedLauncherItems {
    NSArray *savedPages = (NSArray *)[self retrieveFromUserDefaults:@"myLauncherView"];
    
    if(savedPages)
    {
        NSMutableArray *savedLauncherItems = [[NSMutableArray alloc] init];
        
        for (NSArray *page in savedPages)
        {
            NSMutableArray *savedPage = [[NSMutableArray alloc] init];
            for(NSDictionary *item in page)
            {
                NSNumber *version;
                if ((version = [item objectForKey:@"myLauncherViewItemVersion"])) {
                    if ([version intValue] == 2) {
                        [savedPage addObject:[[MyLauncherItem alloc]
                                              initWithTitle:[item objectForKey:@"title"]
                                              iPhoneImage:[item objectForKey:@"image"]
                                              iPadImage:[item objectForKey:@"iPadImage"]
                                              target:[item objectForKey:@"controller"]
                                              targetTitle:[item objectForKey:@"controllerTitle"]
                                              deletable:[[item objectForKey:@"deletable"] boolValue]]];
                    }
                } else {
                    [savedPage addObject:[[MyLauncherItem alloc]
                                          initWithTitle:[item objectForKey:@"title"]
                                          image:[item objectForKey:@"image"]
                                          target:[item objectForKey:@"controller"]
                                          deletable:[[item objectForKey:@"deletable"] boolValue]]];
                }
            }
            
            [savedLauncherItems addObject:savedPage];
        }
        
        return savedLauncherItems;
    }
    
    return nil;
}

-(void)clearSavedLauncherItems {
    [self saveToUserDefaults:nil key:@"myLauncherView"];
    [self saveToUserDefaults:nil key:@"myLauncherViewImmovable"];
}

-(id)retrieveFromUserDefaults:(NSString *)key {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults)
        return [standardUserDefaults objectForKey:key];
    return nil;
}

-(void)saveToUserDefaults:(id)object key:(NSString *)key {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults)
    {
        [standardUserDefaults setObject:object forKey:key];
        [standardUserDefaults synchronize];
    }
}

@end
