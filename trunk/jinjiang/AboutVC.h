//
//  AboutVC.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJUIViewController.h"
#import "ControlView.h"

#import "InfoView.h"
#import "ContactView.h"

@interface AboutVC : JJUIViewController {
    NSInteger index;
    ContactView *contactView;
    InfoView *infoView;
    
    ControlTopView *ct0;
    ControlTopView *ct1;
}

@end
