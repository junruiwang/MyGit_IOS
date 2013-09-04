//
//  InputAccessoryViewController.h
//  
//
//  Created by peng li on 11-11-29.
//  Copyright (c) 2011年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - InputAccessoryDelegate

@protocol InputAccessoryDelegate <NSObject>
@optional
- (void)gotoPreField;
- (void)gotoNextField;
- (void)keyBoardDone;
@end

#pragma mark - InputAccessoryViewController;

@interface InputAccessoryViewController : UIViewController
{
    UIBarButtonItem *doneBtn;
    UISegmentedControl *navSegment;
    id<InputAccessoryDelegate> __weak delegate;
}

@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneBtn;
@property (nonatomic, strong) IBOutlet UISegmentedControl *navSegment;
@property (nonatomic, weak) id<InputAccessoryDelegate> delegate;

- (IBAction)segmentedControlSelected:(id)sender;
- (IBAction)done;

@end
