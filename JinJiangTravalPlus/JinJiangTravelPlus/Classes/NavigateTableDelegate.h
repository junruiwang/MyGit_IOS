//
// Created by huguiqi on 11/24/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#import "HotelFilterNavigation.h"

@protocol HandleSelectedNavigationDelegate <NSObject>

- (void) selectedNavigation : (HotelFilterNavigation*) hotelFilterNavigation;

@end

@interface NavigateTableDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray *navigationArray;
@property (nonatomic, weak) id<HandleSelectedNavigationDelegate> handleSelectedNavigationDelegate;

@end