//
//  CardPassbookViewController.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 4/17/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "CardPassbookViewController.h"
#import "FileManager.h"
#import "SVProgressHUD.h"
#import "CloNetworkUtil.h"

@interface CardPassbookViewController ()

@end

@implementation CardPassbookViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.trackedViewName = @"会员卡passbook弹出添加页面";
    [super viewWillAppear:animated];
}


-(void)generatePassbook
{
    [super initPassbookParser];
    [self.passbookRequestParse generateCardPassbook:self.passbookForm];
}



-(void)writeToFile
{
    NSLog(@"----CardPassbookViewController.writePkpass To File start passData is %i ......",self.passData.length);
    NSString* path = [FileManager fileCachesPath:[NSString stringWithFormat: @"card_%@.pkpass",self.passbookForm.cardNo]];
    NSDictionary *sourceDict = [NSDictionary dictionaryWithObject:self.passData forKey:self.passbookForm.cardNo];
    BOOL res = [sourceDict writeToFile:path atomically:YES];
    if (res == YES) {
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

-(BOOL)readPassFromLocal
{
    NSString* path = [FileManager fileCachesPath:[NSString stringWithFormat: @"card_%@.pkpass",self.passbookForm.cardNo]];
    NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.passData = [dict objectForKey:self.passbookForm.cardNo];
    NSLog(@"---CardPassbookViewController.readPassFromLocal  passData length is %i",[self.passData length]);
    if ([self isNotEmptyPassData]) {
        return YES;
    }
    return NO;
}

-(void)writePassbookUrlToFile
{
    NSLog(@"----CardPassbookViewController.writePassUrl To File passUrl is %@ ......",self.passUrl);
    NSString* path = [FileManager fileCachesPath:[NSString stringWithFormat: @"card_%@.passUrl",self.passbookForm.cardNo]];
    
    NSString *tempUrl = [[NSString alloc] initWithString:[self.passUrl absoluteString]];
    NSDictionary *sourceDict = [NSDictionary dictionaryWithObject:tempUrl forKey:self.passbookForm.cardNo];
    BOOL res = [sourceDict writeToFile:path atomically:YES];
    if (res == YES) {
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

-(BOOL)readPassUrlFromLocal
{
    NSString* path = [FileManager fileCachesPath:[NSString stringWithFormat: @"card_%@.passUrl",self.passbookForm.cardNo]];
    NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *temUrl = [dict objectForKey:self.passbookForm.cardNo];
    if (temUrl) {
        self.passUrl = [[NSURL alloc] initWithString:temUrl];
    }
    NSLog(@"---CardPassbookViewController.readPassUrlFromLocal  passUrl is %@",self.passUrl);
    if (self.passUrl) {
        return YES;
    }
    return NO;
}


#pragma mark - Pass controller delegate
-(void)addPassesViewControllerDidFinish: (PKAddPassesViewController*) controller
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"会员卡passbook弹出添加页面"
                                                    withAction:@"会员卡passbook弹出添加"
                                                     withLabel:@"会员卡passbook弹出添加按钮"
                                                     withValue:nil];
    [UMAnalyticManager eventCount:@"会员卡passbook弹出添加" label:@"会员卡passbook弹出添加按钮"];
    //pass added
    [self.showPassbookViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
