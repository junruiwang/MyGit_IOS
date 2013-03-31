//
//  MyImageView.h
//  Bustime
//
//  Created by 汪君瑞 on 13-3-31.
//  Copyright (c) 2013年 Jerry Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyImageView : UIImageView
{
	id dege;
}
-(void)setdege:(id)ID;
- (id)initWithImage:(UIImage *)image text:(NSString *)text;

@end
