//
//  PassbookRequestParse.h
//  JinJiangTravelPlus
//
//  Created by huguiqi on 13-1-31.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#define kKeyCode  @"code"
#define kKeyPassUrl @"passUrl"
#define kKeyStatuss @"status"

#import "GDataXMLParser.h"
#import "OrderPassbookForm.h"
#import "PassUrlDelegate.h"
#import "CardPassbookForm.h"

@interface PassbookRequestParse : GDataXMLParser <GDataXMLParserDelegate>

@property(nonatomic,strong) id<PassUrlDelegate> passUrlDelegate;

-(void)generateOrderPassbook:(OrderPassbookForm *) passbookForm;
-(void)generateCardPassbook:(CardPassbookForm *)passbookForm;

@end
