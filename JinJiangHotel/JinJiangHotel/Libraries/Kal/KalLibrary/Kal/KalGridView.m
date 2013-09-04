/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>

#import "KalGridView.h"
#import "KalView.h"
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalLogic.h"
#import "KalDate.h"
#import "KalPrivate.h"

#define SLIDE_NONE 0
#define SLIDE_UP 1
#define SLIDE_DOWN 2

#define CheckInDateType 0
#define CheckOUTDateType 1
#define OriginalCheckDateType 2


const CGSize kTileSize = { 46.f, 44.f };

static NSString *kSlideAnimationId = @"KalSwitchMonths";

@interface KalGridView ()
@property (nonatomic, retain) KalTileView *selectedTile;
@property (nonatomic, retain) KalTileView *highlightedTile;
- (void)swapMonthViews;
@end

@implementation KalGridView

@synthesize selectedTile, highlightedTile, transitioning;
@synthesize movedTile;
@synthesize selectedDatesArray;
@synthesize startTile;
@synthesize midMonthView;
@synthesize slideDate;

int showMonthFlag;

- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)theLogic delegate:(id<KalViewDelegate>)theDelegate
{
    // MobileCal uses 46px wide tiles, with a 2px inner stroke 
    // along the top and right edges. Since there are 7 columns,
    // the width needs to be 46*7 (322px). But the iPhone's screen
    // is only 320px wide, so we need to make the
    // frame extend just beyond the right edge of the screen
    // to accomodate all 7 columns. The 7th day's 2px inner stroke
    // will be clipped off the screen, but that's fine because
    // MobileCal does the same thing.
    self.selectedDatesArray = [NSMutableArray arrayWithCapacity:20];
    self.midMonthView = [[[KalMonthView alloc] init] autorelease];
    frame.size.width = 7 * kTileSize.width;
    
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
        logic = [theLogic retain];
        delegate = theDelegate;
        
        CGRect monthRect = CGRectMake(0.f, 0.f, frame.size.width, frame.size.height);
        frontMonthView = [[KalMonthView alloc] initWithFrame:monthRect];
        backMonthView = [[KalMonthView alloc] initWithFrame:monthRect];
        backMonthView.hidden = YES;
        [self addSubview:backMonthView];
        [self addSubview:frontMonthView];
        
        [self jumpToSelectedMonth];
    }
    return self;
}

//- (void)initDateCheckDelegate:(id<KalDateCheckDelegate>)theDelegate
//{
//    checkDateDelegate=theDelegate;
//}

- (void)drawRect:(CGRect)rect
{
    CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 0.92, 0.92, 0.92, 1.0);
    
    // draw the filled rectangle
    CGContextFillRect (UIGraphicsGetCurrentContext(), self.bounds);
    CGRect line;
    line.origin = CGPointMake(0.f, self.height - 1.f);
    line.size = CGSizeMake(self.width, 1.f);
    CGContextFillRect(UIGraphicsGetCurrentContext(), line);
}

- (void)sizeToFit
{
    self.height = frontMonthView.height;
}

#pragma mark -
#pragma mark Touches

- (void)setHighlightedTile:(KalTileView *)tile
{
    if (tile != nil && tile.type != KalTileTypeDisable)
    {
        if (highlightedTile != tile) {
            highlightedTile.highlighted = NO;
            highlightedTile = [tile retain];
            tile.highlighted = YES;
            [tile setNeedsDisplay];
        }
    }
}

- (void)inputCheckInDate:(KalDate *)date
{
    //[delegate setCurrentCheckDateType:CheckInDateType];
    if([frontMonthView tileForDate:date])
    {
        self.selectedTile = [frontMonthView tileForDate:date];
    }
    else
    {
        self.selectedTile = [midMonthView tileForDate:date];
    }
}

- (void)inputCheckOutDate:(KalDate *)date
{
    //[delegate setCurrentCheckDateType:CheckOUTDateType];
    if([frontMonthView tileForDate:date])
    {
        self.selectedTile = [frontMonthView tileForDate:date];
    }
    else
    {
        self.selectedTile = [midMonthView tileForDate:date];
    }
}

- (void)setSelectedTile:(KalTileView *)tile
{
    if (tile != nil && tile.type != KalTileTypeDisable)
    {
        if (selectedTile != tile) {
            //selectedTile.selected = NO;
            selectedTile = [tile retain];
            tile.selected = YES;
            [delegate didSelectDate:tile.date];
        }
    }
    else
    {
    }
}

- (void)receivedTouches:(NSSet *)touches withEvent:event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *hitView = [self hitTest:location withEvent:event];
    
    if (!hitView)
        return;
    
    if ([hitView isKindOfClass:[KalTileView class]]) 
    {
        KalTileView *tile = (KalTileView*)hitView;

        if ([tile.date compare:[KalDate dateFromNSDate:logic.minDate ]] == NSOrderedAscending
            || [tile.date compare:[KalDate dateFromNSDate:logic.maxDate]] == NSOrderedDescending) {
            return;
        }

        if([selectedDatesArray count]<=1)
        {
            selectedTile.selected = NO;
            [self removeSelectedTilesArray];
            if ([tile.date compare:[logic getFromKalDate]]==NSOrderedSame||[tile.date compare:[logic getToKalDate]]==NSOrderedSame)//tile.belongsToAdjacentMonth) 
            {
                self.highlightedTile = tile;
                
                self.startTile=tile;
            } else {
                self.highlightedTile = nil;
                //self.selectedTile = tile;
                self.startTile=tile;
            }
        }
        else
        {
            if (0
              //  [tile.date compare:[selectedDatesArray objectAtIndex:0]]==NSOrderedSame
              //  ||[tile.date compare:[selectedDatesArray lastObject]] == NSOrderedSame
                )
            {
                 if([tile.date compare:[selectedDatesArray objectAtIndex:0]]==NSOrderedSame)
                 {
                     if([frontMonthView tileForDate:[selectedDatesArray lastObject]])
                         self.startTile=[frontMonthView tileForDate:[selectedDatesArray lastObject]];
                         else
                         self.startTile=[midMonthView tileForDate:[selectedDatesArray lastObject]];
                 }
                else
                {
                    if([frontMonthView tileForDate:[selectedDatesArray objectAtIndex:0]])
                        self.startTile=[frontMonthView tileForDate:[selectedDatesArray objectAtIndex:0]];
                    else
                        self.startTile=[midMonthView tileForDate:[selectedDatesArray objectAtIndex:0]];                
                }
            }
            else
            {
                selectedTile.selected = NO;
                [self removeSelectedTilesArray];
                if ([tile.date compare:[logic getFromKalDate]]==NSOrderedSame||[tile.date compare:[logic getToKalDate]]==NSOrderedSame)//tile.belongsToAdjacentMonth) 
                {
                    self.highlightedTile = tile;
                    self.startTile=tile;
                } else {
                    self.highlightedTile = nil;
                    //self.selectedTile = tile;
                    self.startTile=tile;
                }
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    showMonthFlag = 5;
    //selectedTile.selected = NO;
    //[self removeSelectedTilesArray];
    [self receivedTouches:touches withEvent:event];    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL slideFlag = YES;    
    if (slideDate) {
        NSDate *date = [NSDate date];
        slideFlag = NO;
        if([date compare:[slideDate dateByAddingTimeInterval:0.8]]!=NSOrderedAscending) {
            slideFlag = YES;
        }
    }

    if (slideFlag) {
        
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:self];
        UIView *hitView = [self hitTest:location withEvent:event];

        if ([hitView isKindOfClass:[KalTileView class]]) {
            KalTileView *tile = (KalTileView*)hitView;

            if ([tile.date compare:[KalDate dateFromNSDate:logic.minDate ]] == NSOrderedAscending
                || [tile.date compare:[KalDate dateFromNSDate:logic.maxDate]] == NSOrderedDescending
                || startTile == nil) {
                return;
            }

            if ([tile.date compare:[logic getFromKalDate]]==NSOrderedSame||[tile.date compare:[logic getToKalDate]]==NSOrderedSame) //tile.belongsToAdjacentMonth) 
            {
                if ([tile.date compare:[logic getToKalDate]]==NSOrderedSame)//[tile.date compare:[KalDate dateFromNSDate:logic.baseDate]] == NSOrderedDescending)
                {
                    if([selectedDatesArray count] < logic.maxSelectDays 
                       && [[[frontMonthView firstTileOfMonth] date] compare:tile.date] == NSOrderedAscending 
                       && showMonthFlag < 6) {
                        self.slideDate = [NSDate date];
                        //[NSThread sleepForTimeInterval:1.0];
                        //midMonthView = frontMonthView;
                        [delegate showFollowingMonth]; 

                        showMonthFlag = showMonthFlag+1;
                    }
                } else {
                    if([selectedDatesArray count] < logic.maxSelectDays 
                       && [[[frontMonthView firstTileOfMonth] date] compare:tile.date] == NSOrderedDescending 
                       && showMonthFlag > 4) {
                        self.slideDate = [NSDate date];
                        //midMonthView = frontMonthView;
                        [delegate showPreviousMonth];
                        
                        showMonthFlag = showMonthFlag-1;
                        
                    }
                }
                // if the moved tile is in last row, and the last row is hiden, the tile.date is nil, so self.movedTile will be nil too.
                self.movedTile = [frontMonthView tileForDate:tile.date];

            } else {
                self.highlightedTile = nil;
                self.movedTile = tile;
            }

            if (movedTile != nil) {
                [self removeSelectedTilesArray];
                [selectedDatesArray addObject:startTile.date];
                KalDate *midDate = startTile.date;

                if ([startTile.date compare:movedTile.date] == NSOrderedAscending) {                        
                    while ([midDate compare:movedTile.date] == NSOrderedAscending) {
                        midDate = [midDate getNextKalDate];
                        //NSLog(@"%s get next kal date", __FUNCTION__);
                        if([selectedDatesArray count] < logic.maxSelectDays) {
                            [selectedDatesArray addObject:midDate];
                        }
                    }
                } else if ([startTile.date compare:movedTile.date] == NSOrderedDescending) {
                    while ([midDate compare:movedTile.date] == NSOrderedDescending) {
                        midDate = [midDate getPrecedingKalDate];
                        //NSLog(@"%s get preceding kal date", __FUNCTION__);
                        if([selectedDatesArray count] < logic.maxSelectDays) {
                            [selectedDatesArray addObject:midDate];
                        }
                    }
                }

                if ([startTile.date compare:movedTile.date] == NSOrderedAscending) {
                    [self inputCheckInDate:[selectedDatesArray objectAtIndex:0]];
                    [self inputCheckOutDate:[selectedDatesArray lastObject]];
                } else if ([startTile.date compare:movedTile.date] == NSOrderedDescending) {
                    [self inputCheckInDate:[selectedDatesArray lastObject]];
                    [self inputCheckOutDate:[selectedDatesArray objectAtIndex:0]];
                } else if ([selectedDatesArray count]==1) {
                    selectedTile = nil;
                    //[delegate setCurrentCheckDateType:OriginalCheckDateType];
                    self.selectedTile = [frontMonthView tileForDate:[selectedDatesArray objectAtIndex:0]];
                }
            } else {
                //NSLog(@"%s the last row tiles were ignored.", __FUNCTION__);
            }

            [self layoutSelectedTilesArray];    
        }
    }
}

- (void)removeSelectedTilesArray
{
/*
    for (unsigned int i = 0; i < [selectedDatesArray count]; i++)
    {
        KalDate *firstDate = [selectedDatesArray objectAtIndex:i];
        KalTileView *firstTile = [frontMonthView tileForDate:firstDate];
        firstTile.selected = NO;
    }
*/
    for (KalDate *firstDate in selectedDatesArray)
    {
        KalTileView *firstTile = [frontMonthView tileForDate:firstDate];
        firstTile.selected = NO;
    }
    [selectedDatesArray removeAllObjects];
}

- (void)layoutSelectedTilesArray
{
    for (unsigned int j=0;j<[selectedDatesArray count];j++)
    {
        KalDate *firstDate = [selectedDatesArray objectAtIndex:j];
        KalTileView *firstTile = [frontMonthView tileForDate:firstDate];
        firstTile.selected = YES;
    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *hitView = [self hitTest:location withEvent:event];
    
    if ([hitView isKindOfClass:[KalTileView class]]) {
        KalTileView *tile = (KalTileView*)hitView;

        if ([tile.date compare:[KalDate dateFromNSDate:logic.minDate ]] == NSOrderedAscending
            || [tile.date compare:[KalDate dateFromNSDate:logic.maxDate]] == NSOrderedDescending) {
            return;
        }

        if ([selectedDatesArray count] == 0
            && ([tile.date compare:[logic getFromKalDate]] == NSOrderedSame
                || [tile.date compare:[logic getToKalDate]] == NSOrderedSame))//tile.belongsToAdjacentMonth) 
        {
            if ([tile.date compare:[logic getToKalDate]] == NSOrderedSame)//[tile.date compare:[KalDate dateFromNSDate:logic.baseDate]] == NSOrderedDescending) 
            {
                [delegate showFollowingMonth];
            } 
            else
            {
                [delegate showPreviousMonth];
            }
            //self.selectedTile = [frontMonthView tileForDate:tile.date];
        } 
        else 
        {
            //self.selectedTile = tile;
        }
        if ([selectedDatesArray count] == 0)
        {
            //[delegate setCurrentCheckDateType:OriginalCheckDateType];

            if ([tile.date compare:[KalDate dateFromNSDate:logic.maxDate ]] == NSOrderedSame) {
                return;
            }

            self.selectedTile = tile;
            [selectedDatesArray addObject:tile.date];
        }
        if ([selectedDatesArray count] == 1) {
            [selectedDatesArray addObject:[[selectedDatesArray objectAtIndex:0] getNextKalDate]];
            [self inputCheckInDate:[selectedDatesArray objectAtIndex:0]];
            [self inputCheckOutDate:[selectedDatesArray lastObject]];
            [self layoutSelectedTilesArray];
        }
    }
    [self layoutSelectedTilesArray];
    self.highlightedTile = nil;
}

#pragma mark -
#pragma mark Slide Animation

- (void)swapMonthsAndSlide:(int)direction keepOneRow:(BOOL)keepOneRow
{
    backMonthView.hidden = NO;
    
    // set initial positions before the slide
    if (direction == SLIDE_UP) {
        backMonthView.top = keepOneRow
        ? frontMonthView.bottom - kTileSize.height
        : frontMonthView.bottom;
    } else if (direction == SLIDE_DOWN) {
        const unsigned int numWeeksToKeep = keepOneRow ? 1 : 0;
        const int numWeeksToSlide = [backMonthView numWeeks] - numWeeksToKeep;
        backMonthView.top = -numWeeksToSlide * kTileSize.height;
    } else {
        backMonthView.top = 0.f;
    }
    
    // trigger the slide animation
    [UIView beginAnimations:kSlideAnimationId context:NULL]; {
        [UIView setAnimationsEnabled:direction!=SLIDE_NONE];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
        frontMonthView.top = -backMonthView.top;
        backMonthView.top = 0.f;
        
        self.height = backMonthView.height;
        
        [self swapMonthViews];
    } [UIView commitAnimations];
    [UIView setAnimationsEnabled:YES];
}

- (void)slide:(int)direction
{
    self.midMonthView = frontMonthView;
    transitioning = YES;
    
    //[backMonthView showDates:logic.daysInSelectedMonth
    //leadingAdjacentDates:logic.daysInFinalWeekOfPreviousMonth
    //trailingAdjacentDates:logic.daysInFirstWeekOfFollowingMonth];
    [backMonthView showDates:logic];
    
    // At this point, the calendar logic has already been advanced or retreated to the
    // following/previous month, so in order to determine whether there are 
    // any cells to keep, we need to check for a partial week in the month
    // that is sliding offscreen.
    
    BOOL keepOneRow = (direction == SLIDE_UP && [logic.daysInFinalWeekOfPreviousMonth count] > 0)
    || (direction == SLIDE_DOWN && [logic.daysInFirstWeekOfFollowingMonth count] > 0);
    
    [self swapMonthsAndSlide:direction keepOneRow:keepOneRow];
    
    /*
    if ([[[NSDate date] cc_dateByMovingToFirstDayOfTheMonth] isEqual:[[frontMonthView firstTileOfMonth].date NSDate]]) {
        self.selectedTile = [frontMonthView tileForDate:[KalDate dateFromNSDate:[[NSDate date] cc_dateByMovingToBeginningOfDay]]];
    } else {
        self.selectedTile = [frontMonthView firstTileOfMonth];
    }*/
    [self layoutSelectedTilesArray];
}

- (void)slideUp { [self slide:SLIDE_UP]; }
- (void)slideDown { [self slide:SLIDE_DOWN]; }

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    transitioning = NO;
    backMonthView.hidden = YES;
}

#pragma mark -

- (void)selectDate:(KalDate *)date
{
    self.selectedTile = [frontMonthView tileForDate:date];
}

- (void)initWithCheckInDate:(NSDate *)dateIn CheckOutDate:(NSDate *)dateOut
{
    [self removeSelectedTilesArray];
    KalDate *startDate = [KalDate dateFromNSDate:dateIn];
    KalDate *stopDate = [KalDate dateFromNSDate:dateOut];
    KalDate *midDate = startDate;
    
    while ([midDate compare:stopDate] != NSOrderedDescending)
    {
        if([selectedDatesArray count] < logic.maxSelectDays)
        {
            [selectedDatesArray addObject:midDate];
        }
        midDate = [midDate getNextKalDate];
    }
    [self layoutSelectedTilesArray];
    
}

- (void)setCheckInDate:(NSDate *)dateIn CheckOutDate:(NSDate *)dateOut
{
/*
    NSDate *d = [NSDate dateWithTimeInterval:0 sinceDate:logic.minDate];
    NSDate *e = [NSDate dateWithTimeInterval:0 sinceDate:logic.maxDate];
    logic = [logic initForDate:dateIn];
    logic.minDate = d;
    logic.maxDate = e;
*/
    [logic moveToMonthForDate:dateIn];

    [self jumpToSelectedMonth];
    [self removeSelectedTilesArray];
    KalDate *startDate = [KalDate dateFromNSDate:dateIn];
    KalDate *stopDate = [KalDate dateFromNSDate:dateOut];
    KalDate *midDate = startDate;
    
    while ([midDate compare:stopDate] != NSOrderedDescending)
    {
        if([selectedDatesArray count] < logic.maxSelectDays)
        {
            [selectedDatesArray addObject:midDate];
        }
        midDate = [midDate getNextKalDate];
    }
    [self layoutSelectedTilesArray];
}

- (void)getDateRangeMin:(NSDate **)min Max:(NSDate **)max;
{
    if([selectedDatesArray count]>0)
    {
        if([[selectedDatesArray objectAtIndex:0] compare:[selectedDatesArray lastObject]]==NSOrderedAscending)
        {
            KalDate *date = [selectedDatesArray objectAtIndex:0];
            NSDate *date1 = [date NSDate];
            *min = date1;
            date = [selectedDatesArray lastObject];
            date1 = [date NSDate];
            *max = date1;
        }
        else if([[selectedDatesArray objectAtIndex:0] compare:[selectedDatesArray lastObject]]==NSOrderedDescending)
        {
            KalDate *date = [selectedDatesArray objectAtIndex:0];
            NSDate *date1 = [date NSDate];
            *max = date1;
            date = [selectedDatesArray lastObject];
            date1 = [date NSDate];
            *min = date1;
        }
        else if([[selectedDatesArray objectAtIndex:0] compare:[selectedDatesArray lastObject]]==NSOrderedSame)
        {
            KalDate *date = [selectedDatesArray objectAtIndex:0];
            NSDate *date1 = [date NSDate];
            *min = date1;
            date = [date getNextKalDate];
            date1 = [date NSDate];
            *max = date1;
        }
    }
}

- (void)swapMonthViews
{
    KalMonthView *tmp = backMonthView;
    backMonthView = frontMonthView;
    frontMonthView = tmp;
    [self exchangeSubviewAtIndex:[self.subviews indexOfObject:frontMonthView] withSubviewAtIndex:[self.subviews indexOfObject:backMonthView]];
}

- (void)jumpToSelectedMonth
{
    [self slide:SLIDE_NONE];
}

- (void)markTilesForDates:(NSArray *)dates { [frontMonthView markTilesForDates:dates]; }

- (KalDate *)selectedDate { return selectedTile.date; }

#pragma mark -

- (void)dealloc
{
    self.slideDate = nil;
    self.selectedDatesArray = nil;
    self.midMonthView = nil;
    
    [selectedTile release];
    [highlightedTile release];
    [frontMonthView release];
    [backMonthView release];
    [logic release];
    [super dealloc];
}

@end
