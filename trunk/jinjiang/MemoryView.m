//
//  MemoryView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-12-2.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "MemoryView.h"


@implementation MemoryView

static MemoryView *__memoryView=nil;

-(void)report_memory{
    
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        txtView.text=[NSString stringWithFormat:@"占用内存:%f",((double)(info.resident_size)/1024.00)];
        //NSLog(@"Memory used: %u", info.resident_size); //in bytes
    } else {
        txtView.text=@"Error: %s", mach_error_string(kerr);
        //NSLog(@"Error: %s", mach_error_string(kerr));
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        txtView=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        txtView.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
        [self addSubview:txtView];
        // Initialization code
        self.userInteractionEnabled=NO;
        timer= [NSTimer scheduledTimerWithTimeInterval: 1.0/60.0
                                                target: self
                                              selector: @selector(report_memory)
                                              userInfo: nil
                                               repeats: YES];
        
    }
    return self;
}
+(void)addTrack:(UIView *)view frame:(CGRect)rect{
    if(__memoryView==nil){
        __memoryView=[[MemoryView alloc] initWithFrame:rect];
        
    }else{
        __memoryView.frame=rect;
    }
     [view addSubview:__memoryView];
    //[__memoryView release];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [timer invalidate];
    [txtView release];
    [super dealloc];
}

@end
