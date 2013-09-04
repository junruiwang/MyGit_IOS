//
//  JJPassbookViewController.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 4/17/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>
#import "PassUrlDelegate.h"
#import "PassbookRequestParse.h"

@interface JJPassbookViewController :JJViewController<PKAddPassesViewControllerDelegate, PassUrlDelegate>

@property(nonatomic,strong) NSData *passData;
@property(nonatomic,strong) NSURL *passUrl;
@property(nonatomic,strong) UIViewController *showPassbookViewController;
@property(nonatomic, strong) PassbookRequestParse* passbookRequestParse;

-(void)initPassbookParser;

-(void)addToPassbook;
-(BOOL)isNotEmptyPassData;
-(BOOL)filterPassData;
-(void)showPassbookView;
-(BOOL)readPassFromLocal;
-(void)getPassDataForPassUrl;
-(void)writeToFile;
-(void)writePassbookUrlToFile;

+(BOOL)canUsePassbook;

@end
