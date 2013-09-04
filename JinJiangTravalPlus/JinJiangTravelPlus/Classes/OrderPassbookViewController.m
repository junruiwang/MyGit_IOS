//
//  ShowPassbookViewController.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 2/7/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "OrderPassbookViewController.h"
#import "FileManager.h"
#import "SVProgressHUD.h"
#import "CloNetworkUtil.h"

@interface OrderPassbookViewController ()

@end

@implementation OrderPassbookViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated
{
   self.trackedViewName = @"订单passbook弹出添加页面";
    [super viewWillAppear:animated];

}

-(void)generatePassbook
{
    [super initPassbookParser];
    [self.passbookRequestParse generateOrderPassbook:self.passbookForm];
}



-(void)writeToFile
{
    NSLog(@"----writePkpass To File start passData is %i ......",self.passData.length);
    NSString* path = [FileManager fileCachesPath:[NSString stringWithFormat: @"%@.pkpass",self.passbookForm.orderNo]];
    NSDictionary *sourceDict = [NSDictionary dictionaryWithObject:self.passData forKey:self.passbookForm.orderNo];
    BOOL res = [sourceDict writeToFile:path atomically:YES];
    if (res == YES) {
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
}

-(BOOL)readPassFromLocal
{
    NSString* path = [FileManager fileCachesPath:[NSString stringWithFormat: @"%@.pkpass",self.passbookForm.orderNo]];
    NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.passData = [dict objectForKey:self.passbookForm.orderNo];
    NSLog(@"---readPassFromLocal  passData length is %i",[self.passData length]);
    if ([self isNotEmptyPassData]) {
        return YES;
    }
    return NO;
}

-(void)writePassbookUrlToFile
{
    NSLog(@"----writePassUrl To File passUrl is %@ ......",self.passUrl);
    NSString* path = [FileManager fileCachesPath:[NSString stringWithFormat: @"%@.passUrl",self.passbookForm.orderNo]];
    
    NSString *tempUrl = [[NSString alloc] initWithString:[self.passUrl absoluteString]];
    NSDictionary *sourceDict = [NSDictionary dictionaryWithObject:tempUrl forKey:self.passbookForm.orderNo];
    BOOL res = [sourceDict writeToFile:path atomically:YES];
    if (res == YES) {
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

-(BOOL)readPassUrlFromLocal
{
    NSString* path = [FileManager fileCachesPath:[NSString stringWithFormat: @"%@.passUrl",self.passbookForm.orderNo]];
    NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *temUrl = [dict objectForKey:self.passbookForm.orderNo];
    if (temUrl) {
            self.passUrl = [[NSURL alloc] initWithString:temUrl];
    }
    NSLog(@"---readPassUrlFromLocal  passUrl is %@",self.passUrl);
    if (self.passUrl) {
        return YES;
    }
    return NO;
}


#pragma mark - Pass controller delegate
-(void)addPassesViewControllerDidFinish: (PKAddPassesViewController*) controller
{
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"订单passbook弹出添加页面"
                                                    withAction:@"订单passbook弹出添加"
                                                     withLabel:@"订单passbook弹出添加按钮"
                                                     withValue:nil];
    
    [UMAnalyticManager eventCount:@"订单passbook弹出添加" label:@"订单passbook弹出添加按钮"];
    //pass added
    [self.showPassbookViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
