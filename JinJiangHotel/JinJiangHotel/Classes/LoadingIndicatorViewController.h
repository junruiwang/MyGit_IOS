//
//  LoadingIndicator.h
//  
//
//  Created by Lipeng on 11-4-21.
//  Copyright 2011年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingIndicatorViewController : UIViewController
{
    UILabel* loadingIndicatorText;
    UIActivityIndicatorView* activityIndicator;
    UIView* backView;
    NSInteger currentTextIndex;
    NSMutableArray *textArray;
    BOOL isUpdateText;
}

@property (nonatomic, strong) NSMutableArray* textArray;
@property (nonatomic, strong) IBOutlet UILabel* loadingIndicatorText;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (nonatomic, strong) IBOutlet UIView *coverBackView;

- (void)showText:(NSString *)text;
- (void)showTextArray:(NSArray *)texts;
- (void)startAnimating;
- (void)stopAnimating; // should call this method, otherwise the object may not free.

@end
