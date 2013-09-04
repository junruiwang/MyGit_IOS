//
//  RemovePassbookParser.h
//  JinJiangTravelPlus
//
//  Created by huguiqi on 13-2-5.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#define kKeyCode  @"code"
#define kKeyStatuss @"status"

#import "GDataXMLParser.h"
#import "OrderPassbookForm.h"


@interface RemovePassbookParser : GDataXMLParser <GDataXMLParserDelegate>

-(void)request:(OrderPassbookForm *) passbookForm;

@end
