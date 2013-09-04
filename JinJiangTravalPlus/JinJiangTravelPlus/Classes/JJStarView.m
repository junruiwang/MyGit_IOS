//
//  JJStarView.m
//  JinJiangTravelPlus
//
//  Created by Leon on 11/12/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "JJStarView.h"

const unsigned int startTag = 99;

@interface JJStarView()

@property (nonatomic, weak) UIImageView *starImageView1;
@property (nonatomic, weak) UIImageView *starImageView2;
@property (nonatomic, weak) UIImageView *starImageView3;
@property (nonatomic, weak) UIImageView *starImageView4;
@property (nonatomic, weak) UIImageView *starImageView5;

@end

@implementation JJStarView

- (void)setStar:(int)star
{
    _star = star;
    for (unsigned int i=_star; i<5; i++)
    {   ((UIImageView *)[self valueForKey:[NSString stringWithFormat:@"starImageView%d", i+1]]).image = nil;    }
    for (unsigned int i=0; i<_star; i++)
    {   ((UIImageView *)[self valueForKey:[NSString stringWithFormat:@"starImageView%d", i+1]]).image = [UIImage imageNamed:@"star.png"];  }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        for (unsigned int i=0; i<5; i++)
        {
            UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*i, 0, 9, 9)];
            [self addSubview:starImageView];
            [self setValue:starImageView forKey:[NSString stringWithFormat:@"starImageView%d", i+1]];
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];

        for (unsigned int i=0; i<5; i++)
        {
            UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*i, 0, 9, 9)];
            //starImageView.image = [UIImage imageNamed:@"star.png"];
            [self addSubview:starImageView];
            [self setValue:starImageView forKey:[NSString stringWithFormat:@"starImageView%d", i+1]];
        }
    }
    return self;
}

@end

@implementation JJStarViewStrong

@synthesize starImageView1;
@synthesize starImageView2;
@synthesize starImageView3;
@synthesize starImageView4;
@synthesize starImageView5;

- (void)setStar:(int)starz
{
    for (unsigned int i = starz; i < 5; i++)
    {   ((UIImageView *)[self viewWithTag:(startTag+i)]).image = nil;   }
    for (unsigned int i = 0; i < starz; i++)
    {   ((UIImageView *)[self viewWithTag:(startTag+i)]).image = [UIImage imageNamed:@"star.png"];  }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];

        for (unsigned int i = 0; i < 5; i++)
        {
            UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*i, 0, 9, 9)];
            [starImageView setTag:startTag+i];
            [self addSubview:starImageView];
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];

        for (unsigned int i = 0; i < 5; i++)
        {
            UIImageView* starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*i, 0, 9, 9)];
            [starImageView setTag:startTag+i];
            [self addSubview:starImageView];
            [self setValue:starImageView forKey:[NSString stringWithFormat:@"starImageView%d", i+1]];
        }
    }
    return self;
}

@end
