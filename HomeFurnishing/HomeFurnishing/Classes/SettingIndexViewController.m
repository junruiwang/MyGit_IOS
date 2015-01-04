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
#import "LocalFileManager.h"
#import "AppDelegate.h"

@interface SettingIndexViewController ()<MyLauncherViewDelegate,ItemViewControllerDelegate>

@property (nonatomic, strong) MyLauncherView *launcherView;
@property (nonatomic, strong) BaseNavigationController *launcherNavigationController;
@property (nonatomic, strong) NSMutableDictionary *appControllers;
@property(nonatomic, strong) LocalFileManager *localFileManager;

-(BOOL)hasSavedLauncherItems;

-(NSMutableArray *)loadLauncherItems:(MyLauncherItem *)myItem;
-(NSArray*)retrieveFromUserDefaults:(NSString *)key;
-(void)saveToUserDefaults:(id)object key:(NSString *)key;

@end

@implementation SettingIndexViewController

- (LocalFileManager *)localFileManager
{
    if (!_localFileManager)
    {
        _localFileManager = [[LocalFileManager alloc] init];
    }
    return _localFileManager;
}

- (void)viewDidLoad {
    //初始化子组件视图容器
    self.appControllers = [[NSMutableDictionary alloc] init];
    
    //Add your view controllers here to be picked up by the launcher; remember to import them above
    //[[self appControllers] setObject:[MyCustomViewController class] forKey:@"MyCustomViewController"];
    //[[self appControllers] setObject:[MyOtherCustomViewController class] forKey:@"MyOtherCustomViewController"];
    [self.appControllers setObject:[ItemViewController class] forKey:@"ItemViewController"];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //绘制spring board
    [self resetLauncherView];
}

-(void)resetLauncherView
{
    //移除launcherView
    if (self.launcherView) {
        [self.launcherView removeFromSuperview];
        self.launcherView.delegate = nil;
        self.launcherView = nil;
    }
    
    self.launcherView = [[MyLauncherView alloc] initWithFrame:CGRectMake(0, 0, self.mainLauncherView.frame.size.width, self.mainLauncherView.frame.size.height)];
    
    self.launcherView.backgroundColor = [UIColor clearColor];
    [self.launcherView setDelegate:self];
    [self.mainLauncherView addSubview:self.launcherView];
    [self reloadLauncherView];
    
//    if(![self hasSavedLauncherItems])
//    {
        // Set number of immovable items below; only set it when you are setting the pages as the
        // user may still be able to delete these items and setting this then will cause movable
        // items to become immovable.
//         [self.launcherView setNumberOfImmovableItems:1];
        
        // Or uncomment the line below to disable editing (moving/deleting) completely!
        // [self.launcherView setEditingAllowed:NO];
//    }
    
    // Set badge text for a MyLauncherItem using it's setBadgeText: method
//    [(MyLauncherItem *)[[[self.launcherView pages] objectAtIndex:0] objectAtIndex:0] setBadgeText:@"4"];
}

-(void)reloadLauncherView
{
    MyLauncherItem *addItem = [[MyLauncherItem alloc] initWithTitle:kAddSceneModeButton
                                                       relationCode:nil
                                                        iPhoneImage:@"setting_icon"
                                                          iPadImage:@"setting_icon-iPad"
                                                             target:@"ItemViewController"
                                                        targetTitle:@"添加情景模式"
                                                          deletable:NO];
    NSMutableArray *pages = [self loadLauncherItems:addItem];
    
    if (pages) {
        [self.launcherView setPages:pages];
        NSString *currentImmovableKey = [NSString stringWithFormat:@"%@-%@", @"myLauncherViewImmovable", TheAppDelegate.currentServerId];
        [self.launcherView setNumberOfImmovableItems:[(NSNumber *)[self retrieveFromUserDefaults:currentImmovableKey] integerValue]];
    } else {
        [self.launcherView setPages:[NSMutableArray arrayWithObjects:
                                     [NSMutableArray arrayWithObjects:addItem, nil], nil] numberOfImmovableItems:1];
    }
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
    self.launcherView.frame = CGRectMake(0, 0, self.mainLauncherView.frame.size.width, self.mainLauncherView.frame.size.height);
    [self.launcherView layoutLauncher];
}

#pragma mark - MyLauncherItem management

-(BOOL)hasSavedLauncherItems {
    NSString *currentKey = [NSString stringWithFormat:@"%@-%@", @"myLauncherView", TheAppDelegate.currentServerId];
    return ([self retrieveFromUserDefaults:currentKey] != nil);
}

-(void)launcherViewItemSelected:(MyLauncherItem*)item {
    if (![self appControllers] || [self launcherNavigationController]) {
        return;
    }
//    Class viewCtrClass = [self.appControllers objectForKey:[item controllerStr]];
//    UIViewController *controller = [[viewCtrClass alloc] init];
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ItemViewController *controller = [board instantiateViewControllerWithIdentifier:[item controllerStr]];
    controller.execUnit = [self.localFileManager buildLocalFileToObjectByCode:item.relationCode];
    controller.delegate = self;
    
    self.launcherNavigationController = [[BaseNavigationController alloc] initWithRootViewController:controller];
    [[self.launcherNavigationController topViewController] setTitle:item.controllerTitle];
				
    UIView *viewToLaunch = [[self.launcherNavigationController topViewController] view];
    [self.launcherNavigationController.view sizeToFit];
    [self.launcherNavigationController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:[self.launcherNavigationController view]];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.launcherNavigationController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:00.0f];
    [self.view addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self.launcherNavigationController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:00.0f];
    [self.view addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self.launcherNavigationController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:00.0f];
    [self.view addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self.launcherNavigationController.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:00.0f];
    [self.view addConstraint:constraint];
    viewToLaunch.alpha = 0;
    viewToLaunch.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         viewToLaunch.alpha = 1.0;
                         viewToLaunch.transform = CGAffineTransformIdentity;
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

#pragma mark - myLauncher caching

-(NSMutableArray *)loadLauncherItems:(MyLauncherItem *)myItem {
    NSString *currentKey = [NSString stringWithFormat:@"%@-%@", @"myLauncherView", TheAppDelegate.currentServerId];
    NSArray *savedPages = (NSArray *)[self retrieveFromUserDefaults:currentKey];
    
    if(savedPages)
    {
        BOOL isExist = NO;
        NSMutableArray *savedLauncherItems = [[NSMutableArray alloc] init];
        NSInteger index = 0;
        for (NSArray *page in savedPages)
        {
            index += 1;
            NSMutableArray *savedPage = [[NSMutableArray alloc] init];
            for(NSDictionary *item in page)
            {
                NSNumber *version;
                if ((version = [item objectForKey:@"myLauncherViewItemVersion"])) {
                    if ([version intValue] == 2) {
                        NSString *relationCode = [item objectForKey:@"relationCode"];
                        //已存在，更新配置
                        if ([relationCode isEqualToString:myItem.relationCode]) {
                            isExist = YES;
                            [savedPage addObject:[[MyLauncherItem alloc]
                                                  initWithTitle:myItem.title
                                                  relationCode:myItem.relationCode
                                                  iPhoneImage:myItem.image
                                                  iPadImage:myItem.iPadImage
                                                  target:myItem.controllerStr
                                                  targetTitle:myItem.controllerTitle
                                                  deletable:[[item objectForKey:@"deletable"] boolValue]]];
                        } else {
                            [savedPage addObject:[[MyLauncherItem alloc]
                                                  initWithTitle:[item objectForKey:@"title"]
                                                  relationCode:[item objectForKey:@"relationCode"]
                                                  iPhoneImage:[item objectForKey:@"image"]
                                                  iPadImage:[item objectForKey:@"iPadImage"]
                                                  target:[item objectForKey:@"controller"]
                                                  targetTitle:[item objectForKey:@"controllerTitle"]
                                                  deletable:[[item objectForKey:@"deletable"] boolValue]]];
                            
                        }
                        
                        
                    }
                } else {
                    [savedPage addObject:[[MyLauncherItem alloc]
                                          initWithTitle:[item objectForKey:@"title"]
                                          relationCode:[item objectForKey:@"relationCode"]
                                          image:[item objectForKey:@"image"]
                                          target:[item objectForKey:@"controller"]
                                          deletable:[[item objectForKey:@"deletable"] boolValue]]];
                }
            }
            
            if (!isExist) {
                //最后一页的末尾加上新增按钮
                if (index == savedPages.count && myItem != nil) {
                    [savedPage addObject:myItem];
                }
            }
            
            [savedLauncherItems addObject:savedPage];
        }
        
        return savedLauncherItems;
    }
    
    return nil;
}

-(void)addNewLauncherItemPage:(MyLauncherItem *)item {
    NSMutableArray *pages = [self loadLauncherItems:item];
    if (!pages) {
        pages = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:item, nil], nil];
    }
    NSMutableArray *pagesToSave = [[NSMutableArray alloc] init];
    
    for(NSArray *page in pages)
    {
        NSMutableArray *pageToSave = [[NSMutableArray alloc] init];
        
        for(MyLauncherItem *item in page)
        {
            if (![item.title isEqualToString:kAddSceneModeButton]) {
                NSMutableDictionary *itemToSave = [[NSMutableDictionary alloc] init];
                [itemToSave setObject:item.title forKey:@"title"];
                [itemToSave setObject:item.relationCode forKey:@"relationCode"];
                [itemToSave setObject:item.image forKey:@"image"];
                [itemToSave setObject:item.iPadImage forKey:@"iPadImage"];
                [itemToSave setObject:[NSString stringWithFormat:@"%d", [item deletable]] forKey:@"deletable"];
                [itemToSave setObject:item.controllerStr forKey:@"controller"];
                [itemToSave setObject:item.controllerTitle forKey:@"controllerTitle"];
                [itemToSave setObject:[NSNumber numberWithInt:2] forKey:@"myLauncherViewItemVersion"];
                
                [pageToSave addObject:itemToSave];
            }
        }
        [pagesToSave addObject:pageToSave];
    }
    NSString *currentKey = [NSString stringWithFormat:@"%@-%@", @"myLauncherView", TheAppDelegate.currentServerId];
    [self saveToUserDefaults:pagesToSave key:currentKey];
}

-(void)deleteLauncherItemPage:(MyLauncherItem *)item {
    NSMutableArray *pages = [self loadLauncherItems:nil];
    if (pages) {
        NSMutableArray *pagesToSave = [[NSMutableArray alloc] init];
        for(NSArray *page in pages)
        {
            NSMutableArray *pageToSave = [[NSMutableArray alloc] init];
            
            for(MyLauncherItem *myItem in page)
            {
                if (![item.relationCode isEqualToString:myItem.relationCode]) {
                    NSMutableDictionary *itemToSave = [[NSMutableDictionary alloc] init];
                    [itemToSave setObject:myItem.title forKey:@"title"];
                    [itemToSave setObject:myItem.relationCode forKey:@"relationCode"];
                    [itemToSave setObject:myItem.image forKey:@"image"];
                    [itemToSave setObject:myItem.iPadImage forKey:@"iPadImage"];
                    [itemToSave setObject:[NSString stringWithFormat:@"%d", [myItem deletable]] forKey:@"deletable"];
                    [itemToSave setObject:myItem.controllerStr forKey:@"controller"];
                    [itemToSave setObject:myItem.controllerTitle forKey:@"controllerTitle"];
                    [itemToSave setObject:[NSNumber numberWithInt:2] forKey:@"myLauncherViewItemVersion"];
                    
                    [pageToSave addObject:itemToSave];
                }
            }
            [pagesToSave addObject:pageToSave];
        }
        
        NSString *currentKey = [NSString stringWithFormat:@"%@-%@", @"myLauncherView", TheAppDelegate.currentServerId];
        [self saveToUserDefaults:pagesToSave key:currentKey];
    }
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


- (void)removeTopViewPage
{
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
                     }
                     completion:^(BOOL finished){
                         [[self.launcherNavigationController view] removeFromSuperview];
                         ((ItemViewController *)self.launcherNavigationController.topViewController).delegate = nil;
                         [self.launcherNavigationController setDelegate:nil];
                         [self setLauncherNavigationController:nil];
                         //重新布局
                         self.launcherView.frame = CGRectMake(0, 0, self.mainLauncherView.frame.size.width, self.mainLauncherView.frame.size.height);
                         [self reloadLauncherView];
                     }];
}

#pragma mark ItemViewControllerDelegate

- (void)backButtonClicked
{
    [self removeTopViewPage];
}

- (void)saveItemButtonClicked:(MyLauncherItem *)item
{
    [self addNewLauncherItemPage:item];
    [self removeTopViewPage];
}

- (void)delItemButtonClicked:(MyLauncherItem *)item
{
    if (item) {
        [self deleteLauncherItemPage:item];
        [self removeTopViewPage];
    } else {
        [self removeTopViewPage];
    }
}

@end
