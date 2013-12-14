//
//  IndexViewController.h
//  IntelligentHome
//
//  Created by jerry on 13-10-9.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncUdpSocket.h"
#import "BaseServerParser.h"

@interface IndexViewController : UIViewController <UIWebViewDelegate, GCDAsyncUdpSocketDelegate, JsonParserDelegate>

@property (nonatomic,weak) IBOutlet UIWebView *mainWebView;

@end
