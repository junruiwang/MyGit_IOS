//
//  LoginViewController.h
//  ChoiceCourse
//
//  Created by jerry on 12-9-12.
//  Copyright (c) 2012年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseViewController.h"
#import "BannerViewController.h"

@interface LoginViewController : BannerViewController<UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *emailTextField;

- (IBAction)login;
- (IBAction)backgroundTap:(id)sender;

@end
