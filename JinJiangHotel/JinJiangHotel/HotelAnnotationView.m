//
//  HotelAnnotationView.m
//  storyboardTest
//
//  Created by 胡 桂祁 on 8/26/13.
//  Copyright (c) 2013 huguiqi. All rights reserved.
//

#import "HotelAnnotationView.h"
#import "HotelAnnotation.h"

//static CGFloat kMaxViewWidth = 150.0;
//
//static CGFloat kViewWidth = 90;
//static CGFloat kViewLength = 100;
//
//static CGFloat kLeftMargin = 15.0;
//static CGFloat kRightMargin = 5.0;
//static CGFloat kTopMargin = 5.0;
//static CGFloat kBottomMargin = 10.0;
//static CGFloat kRoundBoxLeft = 10.0;

@interface HotelAnnotationView ()

@property (nonatomic, strong) UILabel *annotationLabel;
@property (nonatomic, strong) UIImage *annotationImage;
@property (nonatomic, strong) UIImage *bgImage;

@end

@implementation HotelAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.bgImage = [UIImage imageNamed:@"map_bubble.png"];
    }
    return self;
}

// determine the MKAnnotationView based on the annotation info and reuseIdentifier
//
- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        
        // offset the annotation so it won't obscure the actual lat/long location
        self.centerOffset = CGPointMake(50.0, 50.0);

        HotelAnnotation *hotelAnnotation = (HotelAnnotation *)self.annotation;
        self.annotationImage = hotelAnnotation.topImage;
        
        NSString *priceString = (hotelAnnotation.hotel.price) == 0 ? @"已售完" : [[NSString alloc] initWithFormat:NSLocalizedString(@"￥%d", nil), hotelAnnotation.hotel.price];
        
        CGRect resizeRect = CGRectMake(0, 0, 80, 60);
        resizeRect.origin = (CGPoint){0.0f, 0.0f};
        CGSize newSize = CGSizeMake(resizeRect.size.width, resizeRect.size.height);
        if ([UIScreen instancesRespondToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0f) {
            UIGraphicsBeginImageContextWithOptions(newSize, NO, 2.0f);
        } else {
            UIGraphicsBeginImageContext(newSize);
        }
        
        [self.bgImage drawInRect:CGRectMake(resizeRect.origin.x, resizeRect.origin.y, 71, 60)];
    
        [self.annotationImage drawInRect:CGRectMake(2, 2, 67, 42)];
        
        if (hotelAnnotation.hotel.price == 0) {
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor lightTextColor].CGColor);
        } else {
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor whiteColor].CGColor);
        }
        CGContextSetTextDrawingMode(UIGraphicsGetCurrentContext(), kCGTextFill);
        
        
        CGRect textRect;
        textRect.size = CGSizeMake(60, 20);
        textRect.origin = (CGPoint){20.0f, 43.0f};
        [priceString drawInRect:textRect withFont:[UIFont systemFontOfSize:9]];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.opaque = NO;
        self.image = resizedImage;
    }
    
    return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    // this annotation view has custom drawing code.  So when we reuse an annotation view
    // (through MapView's delegate "dequeueReusableAnnoationViewWithIdentifier" which returns non-nil)
    // we need to have it redraw the new annotation data.
    //
    // for any other custom annotation view which has just contains a simple image, this won't be needed
    //
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    HotelAnnotation *hotelAnnotation = (HotelAnnotation *)self.annotation;

//}

@end
