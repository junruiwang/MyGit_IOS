//
//  WebTouchView.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-29.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WebTouchView : UIWebView <UIWebViewDelegate>{
    NSMutableDictionary *paths;
    NSInteger tounchNum;
}

@end
