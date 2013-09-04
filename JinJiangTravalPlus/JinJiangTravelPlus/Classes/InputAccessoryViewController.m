//
//  InputAccessoryViewController.m
//  
//
//  Created by peng li on 11-11-29.
//  Copyright (c) 2011年 JinJiang. All rights reserved.
//

#import "InputAccessoryViewController.h"

@implementation InputAccessoryViewController

@synthesize doneBtn;
@synthesize navSegment;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)done
{
    if (delegate != nil && [delegate respondsToSelector:@selector(keyBoardDone)])
    {   [delegate keyBoardDone];    }
}

- (IBAction)segmentedControlSelected:(id)sender
{
//  NSLog(@"%s, select sort index %d", __FUNCTION__, segmentedControl.selectedSegmentIndex);
    UISegmentedControl *control = (UISegmentedControl *)sender;
    switch (control.selectedSegmentIndex)
    {
        case 0:
        {
            if (delegate != nil && [delegate respondsToSelector:@selector(gotoPreField)])
            {   [delegate gotoPreField];  } break;
        }
        case 1:
        {
            if (delegate != nil && [delegate respondsToSelector:@selector(gotoNextField)])
            {   [delegate gotoNextField];   }   break;
        }
        default:    {   break;  }
    }
//  control.selected = NO;
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    [navSegment setTitle:NSLocalizedString(@"Previous", nil) forSegmentAtIndex:0];
    [navSegment setTitle:NSLocalizedString(@"Next", nil) forSegmentAtIndex:1];
    doneBtn.title = NSLocalizedString(@"Done", nil);
}

- (void)viewDidUnload
{
    self.doneBtn = nil;
    self.navSegment = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    doneBtn = nil;
    navSegment = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
