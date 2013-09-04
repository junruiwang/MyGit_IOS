//
//  SlideViewController.h
//  IPAD
//
//  Created by he yongzheng on 11-9-27.
//  Copyright 2011年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideViewDelegate <NSObject>
- (void)closeTipsView;
@end

@interface SlideViewController : UIViewController <UIScrollViewDelegate>
{
    UIScrollView *scrollView; 
    UIPageControl *pageController;
    NSMutableArray *imageArray;
    id<SlideViewDelegate> __weak delegate;
    BOOL isPageClosing;
    UIButton *previousPageBtn;
    UIButton *nextPageBtn;
}
@property (nonatomic, weak) id<SlideViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageController;
@property (nonatomic, strong) IBOutlet UIButton *previousPageBtn;
@property (nonatomic, strong) IBOutlet UIButton *nextPageBtn;

@property (nonatomic, strong) NSMutableArray *imageArray;

- (void)ShowImages:(NSArray *)imageNames;
- (IBAction)closeView:(id)sender;
@end
