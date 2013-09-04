//
//  UIStyle.h
//  
//
//  Created by peng li on 11-11-26.
//  Copyright (c) 2011年 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>


#define __NORMAL_STYLE__
//#define __CHRISTMAS_STYLE__

#define __NAVBAR_USE_IMAGE__       // if not use background image, then use tintColor
#ifdef __NAVBAR_USE_IMAGE__
#define SetNavBarStyle(navBar) [navBar setBackgroundImage:[UIImage imageNamed:kNavBarImage]]
#else
#define SetNavBarStyle(navBar) navBar.tintColor = kNavBarTintColor
#endif

//#define __TOOLBAR_USE_IMAGE__       // if not use background image, then use tintColor
#ifdef __TOOLBAR_USE_IMAGE__
#define SetToolbarStyle(toolbar) [toolbar setBackgroundImage:[UIImage imageNamed:kToolbarImage]]
#else
#define SetToolbarStyle(toolbar) toolbar.tintColor = kToolbarTintColor
#endif

// 40,100,180  blue
// 92 55 11 brown
// 150 18 0 dark red
#define RedColor    [UIColor colorWithRed:150.0/255.0 green:18.0/255.0 blue:0 alpha:1.0]
#define BlueColor   [UIColor colorWithRed:0.1568 green:0.392 blue:0.706 alpha:1.0]
#define BrownColor  [UIColor colorWithRed:0.3608 green:0.2157 blue:0.0431 alpha:1.0]
#define BlackColor  [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]
#define kToolbarImage           @"toolbarBg.png"

#ifdef __NORMAL_STYLE__
#define kNavBarTintColor        BlueColor
#define kToolbarTintColor       BlackColor
#define kAddressBarTintColor    BlueColor
#define kSubmitBtnImg           @"lock.png"
#define kSubmitBtnPressedImg    @"unlock.png"
#define kNavBarImage            @"navBarBlueBg.png"
#endif

#ifdef __CHRISTMAS_STYLE__
#define kNavBarTintColor        BlueColor
#define kToolbarTintColor       BrownColor
#define kAddressBarTintColor    BlueColor
#define kSubmitBtnImg           @"christmasLock.png"
#define kSubmitBtnPressedImg    @"christmasUnlock.png"
#define kNavBarImage            @"navBarRedBg.png"
//#define kNavBarImage            @"navBarBlueBg.png"
#endif

//@interface UIStyle : NSObject

//@end
