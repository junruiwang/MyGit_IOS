//
//  RangeSlider.m
//  
//
//  Created by Charlie Mezak on 9/16/10.
//  Modified by Li Peng on 10-11-19.

#import "RangeSlider.h"
#import <QuartzCore/QuartzCore.h>

#define kControlWidth 28
#define kControlHeight 28

@interface RangeSlider (PrivateMethod)

- (void)updateTrackImageViews;
- (void)updateThumbViews;
- (void)setupSliders;
- (void)calculateMinMax;

@end

@implementation RangeSlider

@synthesize min;
@synthesize max;
@synthesize minimumRangeLength;

- (id)initWithFrame:(CGRect)frame
{
    const int x = frame.origin.x;
    const int y = frame.origin.y;
    const unsigned int w = frame.size.width;
    const unsigned int h = frame.size.height;

    if ((self = [super initWithFrame:CGRectMake(x, y, w, h)]))
    {
		min = 0.0;
		max = 1.0;
		minimumRangeLength = 0.0;

		[self setupSliders];
		[self updateTrackImageViews];
	}
    return self;
}

- (void)setupSliders
{
    UIImage* image;
	image = [UIImage imageNamed:@"subRangeTrack.png"]; const int y = (kSliderHeight-image.size.height)/2.0;
    subRangeTrackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, image.size.width, image.size.height)];
	subRangeTrackImageView.image = [image stretchableImageWithLeftCapWidth:2 topCapHeight:image.size.height-2];
    [self addSubview:subRangeTrackImageView];

#ifdef __IPAD__
	image = [UIImage imageNamed:@"slideBar.png"];
#else
    image = [UIImage imageNamed:@"inRangeTrack.png"];
#endif

    const int y0 = (kSliderHeight-image.size.height)/2.0;
    inRangeTrackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y0, self.frame.size.width, image.size.height)];
	inRangeTrackImageView.image = [image stretchableImageWithLeftCapWidth:image.size.width/2.0-1 topCapHeight:image.size.height-2];
    [self addSubview:inRangeTrackImageView];

	image = [UIImage imageNamed:@"superRangeTrack.png"];
    const int x1 = self.frame.size.width-image.size.width;
    const int y1 = (kSliderHeight-image.size.height)/2.0;
    superRangeTrackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x1, y1, image.size.width, image.size.height)];
	superRangeTrackImageView.image = [image stretchableImageWithLeftCapWidth:1 topCapHeight:image.size.height-2];
    [self addSubview:superRangeTrackImageView];

  	image = [UIImage imageNamed:@"slideControl.png"]; const int y2 = (kSliderHeight-kControlHeight)/2.0;
    minSlider = [[UIImageView alloc] initWithFrame:CGRectMake(0, y2, kControlWidth, kControlHeight)];
	minSlider.backgroundColor = [UIColor clearColor];
	minSlider.image = image;
	[self addSubview:minSlider];

    image = [UIImage imageNamed:@"slideControl.png"];
    const int x3 = self.frame.size.width-image.size.width;
    const int y3 = (kSliderHeight-kControlHeight)/2.0;
    maxSlider = [[UIImageView alloc] initWithFrame:CGRectMake(x3, y3, kControlWidth, kControlHeight)];
    maxSlider.backgroundColor = [UIColor clearColor];
	maxSlider.image = image;
	[self addSubview:maxSlider];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	UITouch *touch = [touches anyObject];

    const int x0 = minSlider.frame.origin.x - 20;
    const int y0 = minSlider.frame.origin.y - 20;
    const unsigned int w0 = minSlider.frame.size.width + 40;
    const unsigned int h0 = minSlider.frame.size.height+ 40;
    CGRect minSliderTouchRange = CGRectMake(x0, y0, w0, h0);

    const int x1 = maxSlider.frame.origin.x - 20;
    const int y1 = maxSlider.frame.origin.y - 20;
    const unsigned int w1 = maxSlider.frame.size.width + 40;
    const unsigned int h1 = maxSlider.frame.size.height+ 40;
    CGRect maxSliderTouchRange = CGRectMake(x1, y1, w1, h1);

	if (CGRectContainsPoint(minSliderTouchRange, [touch locationInView:self]))  //if touch is beginning on min slider
    {
        trackingSlider = minSlider;
	}
    else if (CGRectContainsPoint(maxSliderTouchRange, [touch locationInView:self])) //if touch is beginning on max slider
    {
        trackingSlider = maxSlider;
	}
    else
    {
        float newX = [touch locationInView:self].x;
        if (newX < minSlider.frame.origin.x)        // touch on the left side of min slider
        {
            const int yy = minSlider.frame.origin.y;
            minSlider.frame = CGRectMake(newX, yy, kControlWidth, kControlHeight);
        }
        else if (newX > maxSlider.frame.origin.x)   // touch on the right side of max slider
        {
            newX = MIN(newX, self.frame.size.width - kControlWidth);
            const int yy = maxSlider.frame.origin.y;
            maxSlider.frame = CGRectMake(newX, yy, kControlWidth, kControlHeight);
        }
        else if ((newX > minSlider.frame.origin.x + kControlWidth) && (newX < maxSlider.frame.origin.x))
        {
            const int xx = (minSlider.frame.origin.x + kControlWidth);
            if ((newX - xx) < (maxSlider.frame.origin.x - newX))    // move minslider
            {
                const int wc = self.frame.size.width;
                const int minl = minimumRangeLength;
                newX = MAX(0, MIN(newX, wc-kControlWidth*2.0-minl*(wc-kControlWidth*2.0)));

                const int yy = minSlider.frame.origin.y;
                minSlider.frame = CGRectMake(newX, yy, kControlWidth, kControlHeight);
                const int xd = maxSlider.frame.origin.x;
                const int mumL = minimumRangeLength;
                const unsigned int wd = self.frame.size.width;
                const int xxx = MAX(xd, xd+kControlWidth+mumL*(wd-kControlWidth*2.0));
                const int yyy = maxSlider.frame.origin.y;
                maxSlider.frame = CGRectMake(xxx, yyy, kControlWidth, kControlHeight);
            }
            else
            {
                const int minl = minimumRangeLength;
                const unsigned int wa = self.frame.size.width;
                newX = MAX(kControlWidth+minl*(wa-kControlWidth*2.0), MIN(newX, wa-kControlWidth));

                const int yyy = maxSlider.frame.origin.y;
                maxSlider.frame = CGRectMake(newX, yyy, kControlWidth, kControlHeight );

                const int xa = minSlider.frame.origin.x;
                const int xb = maxSlider.frame.origin.x;
                const unsigned int wb = self.frame.size.width;
                const int minn = MIN(xa, xb-kControlWidth-minl*(wb-2.0*kControlWidth));
                const int yy0 = minSlider.frame.origin.y;
                minSlider.frame = CGRectMake(minn, yy0, kControlWidth, kControlHeight);
            }

        }
        [self calculateMinMax];
        [self updateTrackImageViews];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	
	UITouch* touch = [touches anyObject];

	float deltaX = [touch locationInView:self].x - [touch previousLocationInView:self].x;
    int xx, yy; unsigned int ww, hh;

	if (trackingSlider == minSlider)
    {
        const int mina = minSlider.frame.origin.x+deltaX;
        const int minb = self.frame.size.width-kControlWidth*2.0-minimumRangeLength*(self.frame.size.width-kControlWidth*2.0);
		float newX = MAX(0, MIN(mina, minb));

        yy = minSlider.frame.origin.y;
		minSlider.frame = CGRectMake(newX, yy, kControlWidth, kControlHeight);

        const int maxa = maxSlider.frame.origin.x;
        const int maxb = minSlider.frame.origin.x+kControlWidth+minimumRangeLength*(self.frame.size.width-kControlWidth*2.0);
        xx = MAX(maxa, maxb); yy = maxSlider.frame.origin.y;
		maxSlider.frame = CGRectMake(xx, yy, kControlWidth, kControlHeight);
	}
    else if (trackingSlider == maxSlider)
    {
        const float maxa = kControlWidth+minimumRangeLength*(self.frame.size.width-kControlWidth*2.0);
        const float mina = maxSlider.frame.origin.x+deltaX, minb = self.frame.size.width-kControlWidth;
		float newX = MAX(maxa, MIN(mina, minb)); yy = maxSlider.frame.origin.y;

		maxSlider.frame = CGRectMake(newX, yy, kControlWidth, kControlHeight);

        const float min0 = minSlider.frame.origin.x;
        const float min1 = maxSlider.frame.origin.x-kControlWidth-minimumRangeLength*(self.frame.size.width-2.0*kControlWidth);
        xx = MIN(min0, min1); yy = minSlider.frame.origin.y; ww = kControlWidth; hh = kControlHeight;
		minSlider.frame = CGRectMake(xx, yy, ww, hh);
    }

    [self calculateMinMax];
    [self updateTrackImageViews];
}

- (void)updateTrackImageViews
{
    const int x0 = kControlWidth * 0.5;
    const int y0 = subRangeTrackImageView.frame.origin.y;
    const unsigned int w0 = MAX(minSlider.frame.origin.x, subRangeTrackImageView.image.size.width);
    const unsigned int h0 = subRangeTrackImageView.frame.size.height;
    subRangeTrackImageView.frame = CGRectMake(x0, y0, w0, h0);  // This line cause print error info: "invalid image size: 0 x 0"

    const int x1 = minSlider.frame.origin.x + 0.5 * kControlWidth;
    const int y1 = inRangeTrackImageView.frame.origin.y;
    const unsigned int w1 = maxSlider.frame.origin.x - minSlider.frame.origin.x;
    const unsigned int h1 = inRangeTrackImageView.frame.size.height;
    inRangeTrackImageView.frame = CGRectMake(x1, y1, w1, h1);

    const int x2 = maxSlider.frame.origin.x + 0.5 * kControlWidth;
    const int y2 = superRangeTrackImageView.frame.origin.y;
    const unsigned int w2 = MAX(1, self.frame.size.width - maxSlider.frame.origin.x - kControlWidth);
    const unsigned int h2 = superRangeTrackImageView.frame.size.height;
    superRangeTrackImageView.frame = CGRectMake(x2, y2, w2, h2);
} 

- (void)calculateMinMax
{
	float newMax = MIN(1, (maxSlider.frame.origin.x - kControlWidth) / (self.frame.size.width - (2*kControlWidth)));
	float newMin = MAX(0, minSlider.frame.origin.x / (self.frame.size.width - 2.0 * kControlWidth));

	if (newMin != min || newMax != max)
    {
		min = newMin;
		max = newMax;
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

- (void)setMinimumRangeLength:(CGFloat)length
{
	minimumRangeLength = MIN(1.0,MAX(length,0.0)); //length must be between 0 and 1
	[self updateThumbViews];
	[self updateTrackImageViews];
}

- (void)updateThumbViews
{
	const int xx = max*(self.frame.size.width-2*kControlWidth)+kControlWidth;
    maxSlider.frame = CGRectMake(xx, maxSlider.frame.origin.y, kControlWidth, kControlHeight);

    const int mina = min*(self.frame.size.width-2*kControlWidth);
    const int minb = maxSlider.frame.origin.x-kControlWidth-(minimumRangeLength*(self.frame.size.width-kControlWidth*2.0));
    minSlider.frame = CGRectMake(MIN(mina, minb), minSlider.frame.origin.y, kControlWidth, kControlHeight);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	trackingSlider = nil; //we are no longer tracking either slider
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
