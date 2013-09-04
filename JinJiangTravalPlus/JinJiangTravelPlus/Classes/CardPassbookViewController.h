//
//  CardPassbookViewController.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 4/17/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import "JJPassbookViewController.h"
#import "CardPassbookForm.h"

@interface CardPassbookViewController : JJPassbookViewController

@property(nonatomic, strong) CardPassbookForm *passbookForm;

-(void)generatePassbook;
-(BOOL)readPassUrlFromLocal;
-(BOOL)readPassFromLocal;

@end
