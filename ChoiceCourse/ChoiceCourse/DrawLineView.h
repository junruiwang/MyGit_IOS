//
//  DrawLineLabel.h
//  ChoiceCourse
//
//  Created by huguiqi on 12-12-9.
//
//

#import <UIKit/UIKit.h>


static inline float radians(double degrees)
{
    return degrees * 3.14 / 180;
}
@interface DrawLineView : UIView

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (strong, nonatomic) NSString *draw;

@property (nonatomic) CGPoint beginPoint;

@property (nonatomic) CGPoint endPoint;

@property (strong, nonatomic) NSMutableArray *array_points;

@end
