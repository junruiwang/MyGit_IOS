//
//  CourseCell.h
//  ChoiceCourse
//
//  Created by huguiqi on 12-12-8.
//
//

#import <UIKit/UIKit.h>
#import "DrawLineView.h"

@interface CourseCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *courseLabel;

@property (nonatomic,strong) IBOutlet DrawLineView *drawLineLabel;

@property (nonatomic,strong) IBOutlet UIImageView *ramarkImgView;

@end
