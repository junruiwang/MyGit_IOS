//
//  ViewController.m
//  TimeText
//
//  Created by alexkung on 12/11/8.
//  Copyright (c) 2012年 com.sourcenetwork. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    for (int i=0; i<6; i++)
    {
        switch (i)
        {
            case 0:
                if(!yearLabel)
                    yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 20+(20+30)*i, 120, 30)];
                [self.view addSubview:yearLabel];
                break;
                
             case 1:
                if(!mouthLabel)
                    mouthLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 20+(20+30)*i, 120, 30)];
                [self.view addSubview:mouthLabel];
                break;
                
                case 2:
                if(!dayLabel)
                    dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 20+(20+30)*i, 120, 30)];
                [self.view addSubview:dayLabel];
                break;
                
            case 3:
                if(!hourLabel)
                    hourLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 20+(20+30)*i, 120, 30)];
                [self.view addSubview:hourLabel];
                break;
                
            case 4:
                if(!minuteLabel )
                    minuteLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 20+(20+30)*i, 120, 30)];
                [self.view addSubview:minuteLabel];
                break;
                
            case 5:
                if(!sencondLabel)
                    sencondLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 20+(20+30)*i, 120, 30)];
                [self.view addSubview:sencondLabel];
                break;
                
            default:
                break;
        }
    }
    [self setLabelText];
    
}

-(void)setLabelText
{
    NSDateFormatter *tempformatter = [[NSDateFormatter alloc]init];
    [tempformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *now = [NSDate date];
    NSString *tempString = [tempformatter stringFromDate:now];
    
    NSLog(@"tempString:%@",tempString);
    
    NSDate *tempNow = [tempformatter dateFromString:tempString];
    
    NSLog(@"tempNow:%@",tempNow);
    
    NSString *tempTimeString;
    tempTimeString = @"2011-11-8 15:54:00";
    NSDate *tempDate = [tempformatter dateFromString:tempTimeString];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit |NSMinuteCalendarUnit| NSSecondCalendarUnit;
    NSCalendar *slide = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *d = [slide components:unitFlags fromDate:tempDate toDate:tempNow options:0];
    
    yearLabel.text = [NSString stringWithFormat:@"年:%d",[d year]];
    mouthLabel.text = [NSString stringWithFormat:@"月:%d",[d month]];
    dayLabel.text = [NSString stringWithFormat:@"日:%d",[d day]];
    hourLabel.text = [NSString stringWithFormat:@"小时:%d",[d hour]];
    minuteLabel.text = [NSString stringWithFormat:@"分钟%d",[d minute]];
    sencondLabel.text = [NSString stringWithFormat:@"秒:%d",[d second]];
    
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
