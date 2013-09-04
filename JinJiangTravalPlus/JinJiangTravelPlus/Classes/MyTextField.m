//
//  MyTextField.m
//  JinJiang
//
//  Created by jerry on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds , 5 , 8 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds , 5 , 8 );
}

@end
