//
//  BannerViewController.h
//  ChoiceCourse
//
//  Created by jerry on 13-3-28.
//
//

#import <UIKit/UIKit.h>
#import "GADBannerViewDelegate.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "GAI.h"

@interface BannerViewController : GAITrackedViewController<GADBannerViewDelegate>

@property(nonatomic, strong) GADBannerView *adBanner;

- (GADRequest *)createRequest;

@end
