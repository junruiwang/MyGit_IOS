//
//  RangeSlider.h
//  
//
//  Created by Charlie Mezak on 9/16/10.
//  Modified by Li Peng on 10-11-19.


#import <UIKit/UIKit.h>

#define kSliderHeight 50//9

@interface RangeSlider : UIControl
{
	float min, max; //the min and max of the range
	float minimumRangeLength; //the minimum allowed range size

	UIImageView* minSlider;
    UIImageView* maxSlider;
    UIImageView* backgroundImageView;
    UIImageView* subRangeTrackImageView;
    UIImageView* superRangeTrackImageView;
    UIImageView* inRangeTrackImageView; // the sliders representing the min and max, and a background view;

    UIView *trackingSlider; // a variable to keep track of which slider we are tracking (if either)
}

@property (nonatomic) float min;
@property (nonatomic) float max;
@property (nonatomic) float minimumRangeLength;

@end
