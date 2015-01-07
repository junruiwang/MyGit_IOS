//
//  ItemViewController.m
//  HomeFurnishing
//
//  Created by jrwang on 14-12-13.
//  Copyright (c) 2014年 handpay. All rights reserved.
//

#import "ItemViewController.h"
#import "Constants.h"
#import "SceneListViewController.h"
#import "SceneTableCell.h"
#import "ValidateInputUtil.h"
#import "LocalFileManager.h"

#define ICON_IMAGE_TAG  100
#define TABLE_ROW_INDEX_START 300

@interface ItemViewController ()

@property(nonatomic, strong) UIView *overlayView;
@property(nonatomic, strong) UIView *imagePageView;
@property(nonatomic, strong) UIScrollView *iconView;
@property(nonatomic, strong) UIView *sceneListView;
@property(nonatomic, strong) NSMutableArray *btnIconList;
@property(nonatomic, strong) UIImageView *tapImageView;
@property(nonatomic, strong) NSString *imageNameStr;
@property(nonatomic, strong) SceneListViewController *sceneListViewController;
@property(nonatomic, strong) LocalFileManager *localFileManager;

@end

@implementation ItemViewController

- (SceneListViewController *)sceneListViewController
{
    if (!_sceneListViewController)
    {
        _sceneListViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                   instantiateViewControllerWithIdentifier:@"SceneListViewController"];
    }
    return _sceneListViewController;
}

- (LocalFileManager *)localFileManager
{
    if (!_localFileManager)
    {
        _localFileManager = [[LocalFileManager alloc] init];
    }
    return _localFileManager;
}

- (ExecutionUnit *)execUnit
{
    if (!_execUnit) {
        _execUnit = [[ExecutionUnit alloc] init];
    }
    return _execUnit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnIconList = [NSMutableArray arrayWithObjects:@"aircona.png", @"curtain.png", @"curtaina.png", @"dinner.png", @"entertainment.png", @"fitting.png", @"gym.png", @"home_arming.png", @"home_at.png", @"home_away.png", @"home_disarm.png", @"home_midnight.png", @"makeup.png", @"meeting.png", @"party.png", @"playground.png", @"pray.png", @"romance.png", @"shower.png", @"silent.png", @"sleeping_day.png", @"sleeping_night.png", @"study.png", @"summer.png", @"winter.png", nil];
    
    [self loadPopImageView];
    [self loadPopSceneListView];
    // Do any additional setup after loading the view.
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
        case UIDeviceOrientationPortraitUpsideDown:
            self.bgImageView.image = [UIImage imageNamed:@"background-Portrait.png"];
            break;
        default:
            break;
    }
    
    //初始化控件原始值
    self.imageNameStr = self.execUnit.imageName;
    if (self.imageNameStr) {
        [self.imageBtn setImage:[UIImage imageNamed:self.imageNameStr] forState:UIControlStateNormal];
        [self.imageBtn setImage:[UIImage imageNamed:self.imageNameStr] forState:UIControlStateHighlighted];
    }
    if (self.execUnit.cName) {
        self.cnField.text = self.execUnit.cName;
    }
    if (self.execUnit.eName) {
        self.enField.text = self.execUnit.eName;
    }
    if (self.execUnit.displayNumber == 0) {
        self.cnButton.selected = YES;
        self.enButton.selected = NO;
    } else if (self.execUnit.displayNumber == 1) {
        self.enButton.selected = YES;
        self.cnButton.selected = NO;
    }
    [self.selSceneTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)iconButtonClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tagIndex = btn.tag;
    self.imageNameStr = self.btnIconList[tagIndex - ICON_IMAGE_TAG];
    self.tapImageView.center = btn.center;
}

- (void)submitButtonClicked:(id)sender
{
    if (self.imageNameStr) {
        [self.imageBtn setImage:[UIImage imageNamed:self.imageNameStr] forState:UIControlStateNormal];
        [self.imageBtn setImage:[UIImage imageNamed:self.imageNameStr] forState:UIControlStateHighlighted];
    }
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.overlayView.alpha = 0;
                         self.imagePageView.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
                     }
                     completion:^(BOOL finished){
                         self.imagePageView.hidden = YES;
                         self.imagePageView.transform = CGAffineTransformIdentity;
                     }];
}

- (void)cancelButtonClicked:(id)sender
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.overlayView.alpha = 0;
                         self.imagePageView.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
                     }
                     completion:^(BOOL finished){
                         self.imagePageView.hidden = YES;
                         self.imagePageView.transform = CGAffineTransformIdentity;
                     }];
}

- (void)confirmSelectClicked:(id)sender
{
    self.execUnit.sceneArray = self.sceneListViewController.selectedSceneList;
    for (NSMutableDictionary *dict in self.execUnit.sceneArray) {
        [dict setObject:@"1" forKey:@"isSelected"];
    }
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.overlayView.alpha = 0;
                         self.sceneListView.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
                     }
                     completion:^(BOOL finished){
                         self.sceneListView.hidden = YES;
                         self.sceneListView.transform = CGAffineTransformIdentity;
                         [self.selSceneTableView reloadData];
                     }];
}

- (void)cancelSelectClicked:(id)sender
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.overlayView.alpha = 0;
                         self.sceneListView.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
                     }
                     completion:^(BOOL finished){
                         self.sceneListView.hidden = YES;
                         self.sceneListView.transform = CGAffineTransformIdentity;
                     }];
}

- (void)refreshSelectClicked:(id)sender
{
    [self.sceneListViewController loadRemoteSceneList];
}

- (IBAction)imageButtonClicked:(id)sender
{
    self.imagePageView.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
    self.imagePageView.hidden = NO;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.overlayView.alpha = 0.7;
                         self.imagePageView.transform = CGAffineTransformIdentity;
                     }
                     completion:NULL];
    
}

- (IBAction)sceneButtonClicked:(id)sender
{
    self.sceneListView.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
    self.sceneListView.hidden = NO;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.overlayView.alpha = 0.7;
                         self.sceneListView.transform = CGAffineTransformIdentity;
                     }
                     completion:NULL];
}

- (IBAction)backBtnClicked:(id)sender
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(backButtonClicked)])
    {
        [self.delegate backButtonClicked];
    }
}

- (IBAction)saveBtnClicked:(id)sender
{
    if (![ValidateInputUtil isNotEmpty:self.imageNameStr fieldCName:@"请选择图标"]) {
        return;
    }
    if (![ValidateInputUtil isNotEmpty:self.cnField.text fieldCName:@"请输入中文名"]) {
        return;
    }
    if (![ValidateInputUtil isNotEmpty:self.enField.text fieldCName:@"请输入英文名"]) {
        return;
    }
    if (!self.cnButton.selected && !self.enButton.selected) {
        [ValidateInputUtil showAlertMessage:@"请在显示的语言后面打勾√"];
        return;
    }
    if (self.execUnit.sceneArray == nil || self.execUnit.sceneArray.count == 0) {
        [ValidateInputUtil showAlertMessage:@"请勾选至少一个情景"];
        return;
    }
    
    //set value
    NSString *trimText = [self.execUnit.executCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimText == nil || [trimText isEqualToString:@""])
    {
        self.execUnit.executCode = [[NSUUID UUID] UUIDString];
    }
    self.execUnit.imageName = self.imageNameStr;
    self.execUnit.cName = self.cnField.text;
    self.execUnit.eName = self.enField.text;
    if (self.enButton.selected) {
        self.execUnit.displayNumber = 1;
    } else {
        self.execUnit.displayNumber = 0;
    }
    
    NSMutableArray *selAry = [[NSMutableArray alloc] initWithCapacity:5];
    for (NSMutableDictionary *dict in self.execUnit.sceneArray) {
        NSString *isSelected = [dict objectForKey:@"isSelected"];
        if ([isSelected isEqualToString:@"1"]) {
            [selAry addObject:dict];
        }
    }
    self.execUnit.sceneArray = [selAry mutableCopy];
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(saveItemButtonClicked:)])
    {
        //保存信息
        if ([self.localFileManager insertIntoLocalWithObject:self.execUnit]) {
            //设置场景
            NSString *displayName = @"";
            if (self.execUnit.displayNumber == 0) {
                displayName = self.execUnit.cName;
            } else {
                displayName = self.execUnit.eName;
            }
            
            MyLauncherItem *item = [[MyLauncherItem alloc] initWithTitle:displayName
                                                            relationCode:self.execUnit.executCode
                                                             iPhoneImage:self.execUnit.imageName
                                                               iPadImage:self.execUnit.imageName
                                                                  target:@"ItemViewController"
                                                             targetTitle:@"情景设置"
                                                               deletable:YES];
            
            [self.delegate saveItemButtonClicked:item];
        }
    }
}

- (IBAction)deleteBtnClicked:(id)sender
{
    NSString *trimText = [self.execUnit.executCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimText == nil || [trimText isEqualToString:@""])
    {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(delItemButtonClicked:)])
        {
            [self.delegate delItemButtonClicked:nil];
        }
    } else {
        if ([self.localFileManager deleteObjectInLocal:self.execUnit.executCode]) {
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(delItemButtonClicked:)])
            {
                MyLauncherItem *item = [[MyLauncherItem alloc] initWithTitle:@""
                                                                relationCode:self.execUnit.executCode
                                                                 iPhoneImage:self.execUnit.imageName
                                                                   iPadImage:self.execUnit.imageName
                                                                      target:@"ItemViewController"
                                                                 targetTitle:@"情景设置"
                                                                   deletable:YES];
                [self.delegate delItemButtonClicked:item];
            }
        }
        
    }
}

- (IBAction)cnButtonClicked:(id)sender
{
    self.enButton.selected = NO;
    self.cnButton.selected = !self.cnButton.selected;
}

- (IBAction)enButtonClicked:(id)sender
{
    self.cnButton.selected = NO;
    self.enButton.selected = !self.enButton.selected;
}


- (void)loadPopImageView
{
    //添加遮罩层
    if (!self.overlayView)
    {
        self.overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.alpha = 0;
        self.overlayView.autoresizesSubviews = YES;
        self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:self.overlayView];
    }
    //添加imagePageView视图
    self.imagePageView = [[UIView alloc] init];
    self.imagePageView.backgroundColor = COLOR(234,237,250);
    self.imagePageView.layer.cornerRadius = 5;
    self.imagePageView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.imagePageView.layer.borderWidth = 1.0;
    [self.imagePageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.imagePageView];
    //imagePageView添加约束
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.imagePageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:200.0f];
    [self.view addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self.imagePageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:00.0f];
    [self.view addConstraint:constraint];
    [self.imagePageView addConstraint:[NSLayoutConstraint constraintWithItem:self.imagePageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:600.0f]];
    [self.imagePageView addConstraint:[NSLayoutConstraint constraintWithItem:self.imagePageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:450.0f]];
    
    UILabel *selIcon = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
    selIcon.backgroundColor = [UIColor clearColor];
    selIcon.text = @"选择图标";
    selIcon.textColor = COLOR(134,210,235);
    selIcon.font = [UIFont systemFontOfSize:20];
    [self.imagePageView addSubview:selIcon];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 600, 1)];
    line.backgroundColor = COLOR(134,210,235);
    [self.imagePageView addSubview:line];
    
    //添加iconView到imagePageView 并添加约束
    self.iconView = [[UIScrollView alloc] init];
    self.iconView.backgroundColor = [UIColor clearColor];
    
    [self.iconView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.imagePageView addSubview:self.iconView];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imagePageView attribute:NSLayoutAttributeTop multiplier:1.0f constant:60.0f];
    [self.imagePageView addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imagePageView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:00.0f];
    [self.imagePageView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.imagePageView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:00.0f];
    [self.imagePageView addConstraint:constraint];
    [self.iconView addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:300.0f]];
    
    self.iconView.contentSize = CGSizeMake(600, 500);
    self.iconView.bounces = NO;
    self.iconView.directionalLockEnabled = YES;
    self.iconView.showsHorizontalScrollIndicator = NO;
    self.iconView.showsVerticalScrollIndicator = YES;
    
    NSInteger startX = 23;
    NSInteger startY = 20;
    NSInteger xOff = 25;
    NSInteger yOff = 25;
    for (NSInteger i=0; i < self.btnIconList.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            
        }else if (i % 6 != 0){
            startX += (72 + xOff);
        }else{
            startY += (72 + yOff);
            startX = 23;
        }
        btn.tag = ICON_IMAGE_TAG + i;
        btn.frame = CGRectMake(startX, startY, 72, 72);
        [btn setImage:[UIImage imageNamed:self.btnIconList[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:self.btnIconList[i]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(iconButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.iconView addSubview:btn];
    }
    UIImageView *lineBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 380, 600, 1)];
    lineBottom.backgroundColor = COLOR(134,210,235);
    [self.imagePageView addSubview:lineBottom];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(240, 400, 56, 30);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"book.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.imagePageView addSubview:submitBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(340, 400, 56, 30);
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"book.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.imagePageView addSubview:cancelBtn];
    
    self.tapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 100, 100)];
    self.tapImageView.image = [UIImage imageNamed:@"icon_selected"];
    [self.iconView addSubview:self.tapImageView];
    
    self.imagePageView.hidden = YES;
}

- (void)loadPopSceneListView
{
    //添加遮罩层
    if (!self.overlayView)
    {
        self.overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.alpha = 0;
        self.overlayView.autoresizesSubviews = YES;
        self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:self.overlayView];
    }
    //添加imagePageView视图
    self.sceneListView = [[UIView alloc] init];
    self.sceneListView.backgroundColor = COLOR(234,237,250);
    self.sceneListView.layer.cornerRadius = 5;
    self.sceneListView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.sceneListView.layer.borderWidth = 1.0;
    [self.sceneListView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.sceneListView];
    //imagePageView添加约束
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.sceneListView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:200.0f];
    [self.view addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self.sceneListView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:00.0f];
    [self.view addConstraint:constraint];
    [self.sceneListView addConstraint:[NSLayoutConstraint constraintWithItem:self.sceneListView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:400.0f]];
    [self.sceneListView addConstraint:[NSLayoutConstraint constraintWithItem:self.sceneListView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:450.0f]];
    
    UILabel *selIcon = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
    selIcon.backgroundColor = [UIColor clearColor];
    selIcon.text = @"选择情景";
    selIcon.textColor = COLOR(134,210,235);
    selIcon.font = [UIFont systemFontOfSize:20];
    [self.sceneListView addSubview:selIcon];
    
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(350, 10, 30, 30);
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"synchronized"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshSelectClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.sceneListView addSubview:refreshBtn];
    
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 400, 1)];
    line.backgroundColor = COLOR(134,210,235);
    [self.sceneListView addSubview:line];
    
    [self.sceneListViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.sceneListView addSubview:self.sceneListViewController.view];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.sceneListViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.sceneListView attribute:NSLayoutAttributeTop multiplier:1.0f constant:55.0f];
    [self.sceneListView addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self.sceneListViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.sceneListView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:00.0f];
    [self.sceneListView addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self.sceneListViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.sceneListView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:00.0f];
    [self.sceneListView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.sceneListViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.sceneListView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-75.0f];
    [self.sceneListView addConstraint:constraint];
    
    UIImageView *lineBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 380, 400, 1)];
    lineBottom.backgroundColor = COLOR(134,210,235);
    [self.sceneListView addSubview:lineBottom];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(140, 400, 56, 30);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    [submitBtn addTarget:self action:@selector(confirmSelectClicked:) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"book.png"] forState:UIControlStateNormal];
    [self.sceneListView addSubview:submitBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(240, 400, 56, 30);
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelSelectClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"book.png"] forState:UIControlStateNormal];
    [self.sceneListView addSubview:cancelBtn];
    
    self.sceneListView.hidden = YES;
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
        case UIDeviceOrientationPortraitUpsideDown:
            self.bgImageView.image = [UIImage imageNamed:@"background-Portrait.png"];
            break;
        default:
            break;
    }
    self.overlayView.frame = self.view.frame;
}

- (void)checkButtonClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
    NSInteger tagNum = btn.tag - TABLE_ROW_INDEX_START;
    NSMutableDictionary *dict = [self.execUnit.sceneArray objectAtIndex:tagNum];
    
    if (btn.selected) {
        [dict setObject:@"1" forKey:@"isSelected"];
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateSelected];
    } else {
        [dict setObject:@"0" forKey:@"isSelected"];
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateSelected];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.execUnit.sceneArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.execUnit.sceneArray objectAtIndex:[indexPath row]];
    SceneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SceneSelectedTableCell"];
    cell.selBtn.tag = TABLE_ROW_INDEX_START + [indexPath row];
    [cell.selBtn addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.selBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateNormal];
    [cell.selBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateHighlighted];
    [cell.selBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateSelected];
    cell.selBtn.selected = YES;
    cell.separatorImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_detail.png"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [dict objectForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
