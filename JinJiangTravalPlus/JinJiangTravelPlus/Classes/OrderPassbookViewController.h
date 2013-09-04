//
//  ShowPassbookViewController.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 2/7/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>
#import "JJPassbookViewController.h"

@interface OrderPassbookViewController : JJPassbookViewController


@property(nonatomic, strong) OrderPassbookForm *passbookForm;

-(void)generatePassbook;
-(BOOL)readPassUrlFromLocal;
-(BOOL)readPassFromLocal;

@end
