//
//  LineChartView.m
//  WeatherReport
//
//  Created by jerry on 13-4-24.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "LineChartView.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface LineChartView()
{
    CALayer *linesLayer;
    UIView *popView;
    UILabel *disLabel;
}

@end

@implementation LineChartView

@synthesize array;

@synthesize hInterval,vInterval;

@synthesize vDesc;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        hInterval = 10;
        vInterval = 55;
        
        self.dateAryDesc = [[NSMutableArray alloc] initWithCapacity:6];
        self.weekAryDesc = [[NSMutableArray alloc] initWithCapacity:6];
        self.lowTempAry = [[NSMutableArray alloc] initWithCapacity:6];
        self.highTempAry = [[NSMutableArray alloc] initWithCapacity:6];
        self.weather = TheAppDelegate.modelWeather;
        //初始化日期模型
        NSDate *rightNow = [NSDate date];
        [self initDayArray:rightNow];
        [self initWeekArray:rightNow];
        
        //初始化天气模型
        [self convertTempToArray:self.weather._10temp1];
        [self convertTempToArray:self.weather._11temp2];
        [self convertTempToArray:self.weather._12temp3];
        [self convertTempToArray:self.weather._13temp4];
        [self convertTempToArray:self.weather._14temp5];
        [self convertTempToArray:self.weather._15temp6];
        
    }
    return self;
}

#define ZeroPoint CGPointMake(30,460)

- (void)drawRect:(CGRect)rect
{
    [self setClearsContextBeforeDrawing: YES];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i=0; i<self.dateAryDesc.count; i++) {
        //顶部日期展示
        UILabel *topDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(vInterval-1)+5, 10, 40, 15)];
        [topDateLabel setTextAlignment:UITextAlignmentCenter];
        [topDateLabel setBackgroundColor:[UIColor clearColor]];
        [topDateLabel setTextColor:[UIColor whiteColor]];
        topDateLabel.numberOfLines = 1;
        topDateLabel.adjustsFontSizeToFitWidth = YES;
        topDateLabel.minimumFontSize = 1.0f;
        topDateLabel.font = [UIFont systemFontOfSize:14];
        [topDateLabel setText:[self.weekAryDesc objectAtIndex:i]];
        [self addSubview:topDateLabel];
        
        //底部日期
        UILabel *bottomDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(vInterval-1)+5, self.frame.size.height-30, 40, 15)];
        [bottomDateLabel setTextAlignment:UITextAlignmentCenter];
        [bottomDateLabel setBackgroundColor:[UIColor clearColor]];
        [bottomDateLabel setTextColor:[UIColor whiteColor]];
        bottomDateLabel.numberOfLines = 1;
        bottomDateLabel.adjustsFontSizeToFitWidth = YES;
        bottomDateLabel.minimumFontSize = 1.0f;
        bottomDateLabel.font = [UIFont systemFontOfSize:14];
        [bottomDateLabel setText:[self.dateAryDesc objectAtIndex:i]];
        [self addSubview:bottomDateLabel];
        
        switch (i) {
            case 0:
            {
                UILabel *dayWeatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(vInterval-1)+5, 30, 40, 15)];
                [dayWeatherLabel setTextAlignment:UITextAlignmentCenter];
                [dayWeatherLabel setBackgroundColor:[UIColor clearColor]];
                [dayWeatherLabel setTextColor:[UIColor whiteColor]];
                dayWeatherLabel.numberOfLines = 1;
                dayWeatherLabel.adjustsFontSizeToFitWidth = YES;
                dayWeatherLabel.minimumFontSize = 1.0f;
                dayWeatherLabel.font = [UIFont systemFontOfSize:12];
                dayWeatherLabel.text = self.weather._34img_title1;
                [self addSubview:dayWeatherLabel];
                
                
                UILabel *nightWeatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(vInterval-1)+5, self.frame.size.height-50, 40, 15)];
                [nightWeatherLabel setTextAlignment:UITextAlignmentCenter];
                [nightWeatherLabel setBackgroundColor:[UIColor clearColor]];
                [nightWeatherLabel setTextColor:[UIColor whiteColor]];
                nightWeatherLabel.numberOfLines = 1;
                nightWeatherLabel.adjustsFontSizeToFitWidth = YES;
                nightWeatherLabel.minimumFontSize = 1.0f;
                nightWeatherLabel.font = [UIFont systemFontOfSize:12];
                nightWeatherLabel.text = self.weather._35img_title2;
                [self addSubview:nightWeatherLabel];
               break; 
            }
            case 1:
            {
                UILabel *dayWeatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(vInterval-1)+5, 30, 40, 15)];
                [dayWeatherLabel setTextAlignment:UITextAlignmentCenter];
                [dayWeatherLabel setBackgroundColor:[UIColor clearColor]];
                [dayWeatherLabel setTextColor:[UIColor whiteColor]];
                dayWeatherLabel.numberOfLines = 1;
                dayWeatherLabel.adjustsFontSizeToFitWidth = YES;
                dayWeatherLabel.minimumFontSize = 1.0f;
                dayWeatherLabel.font = [UIFont systemFontOfSize:12];
                dayWeatherLabel.text = self.weather._36img_title3;
                [self addSubview:dayWeatherLabel];
                
                
                UILabel *nightWeatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(vInterval-1)+5, self.frame.size.height-50, 40, 15)];
                [nightWeatherLabel setTextAlignment:UITextAlignmentCenter];
                [nightWeatherLabel setBackgroundColor:[UIColor clearColor]];
                [nightWeatherLabel setTextColor:[UIColor whiteColor]];
                nightWeatherLabel.numberOfLines = 1;
                nightWeatherLabel.adjustsFontSizeToFitWidth = YES;
                nightWeatherLabel.minimumFontSize = 1.0f;
                nightWeatherLabel.font = [UIFont systemFontOfSize:12];
                nightWeatherLabel.text = self.weather._37img_title4;
                [self addSubview:nightWeatherLabel];
                break;
            }
            case 2:
            {
                UILabel *dayWeatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(vInterval-1)+5, 30, 40, 15)];
                [dayWeatherLabel setTextAlignment:UITextAlignmentCenter];
                [dayWeatherLabel setBackgroundColor:[UIColor clearColor]];
                [dayWeatherLabel setTextColor:[UIColor whiteColor]];
                dayWeatherLabel.numberOfLines = 1;
                dayWeatherLabel.adjustsFontSizeToFitWidth = YES;
                dayWeatherLabel.minimumFontSize = 1.0f;
                dayWeatherLabel.font = [UIFont systemFontOfSize:12];
                dayWeatherLabel.text = self.weather._38img_title5;
                [self addSubview:dayWeatherLabel];
                
                
                UILabel *nightWeatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(vInterval-1)+5, self.frame.size.height-50, 40, 15)];
                [nightWeatherLabel setTextAlignment:UITextAlignmentCenter];
                [nightWeatherLabel setBackgroundColor:[UIColor clearColor]];
                [nightWeatherLabel setTextColor:[UIColor whiteColor]];
                nightWeatherLabel.numberOfLines = 1;
                nightWeatherLabel.adjustsFontSizeToFitWidth = YES;
                nightWeatherLabel.minimumFontSize = 1.0f;
                nightWeatherLabel.font = [UIFont systemFontOfSize:12];
                nightWeatherLabel.text = self.weather._39img_title6;
                [self addSubview:nightWeatherLabel];
                break;
            }
            case 3:
            {
                UILabel *dayWeatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(vInterval-1)+5, 30, 40, 15)];
                [dayWeatherLabel setTextAlignment:UITextAlignmentCenter];
                [dayWeatherLabel setBackgroundColor:[UIColor clearColor]];
                [dayWeatherLabel setTextColor:[UIColor whiteColor]];
                dayWeatherLabel.numberOfLines = 1;
                dayWeatherLabel.adjustsFontSizeToFitWidth = YES;
                dayWeatherLabel.minimumFontSize = 1.0f;
                dayWeatherLabel.font = [UIFont systemFontOfSize:12];
                dayWeatherLabel.text = self.weather._40img_title7;
                [self addSubview:dayWeatherLabel];
                
                
                UILabel *nightWeatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(vInterval-1)+5, self.frame.size.height-50, 40, 15)];
                [nightWeatherLabel setTextAlignment:UITextAlignmentCenter];
                [nightWeatherLabel setBackgroundColor:[UIColor clearColor]];
                [nightWeatherLabel setTextColor:[UIColor whiteColor]];
                nightWeatherLabel.numberOfLines = 1;
                nightWeatherLabel.adjustsFontSizeToFitWidth = YES;
                nightWeatherLabel.minimumFontSize = 1.0f;
                nightWeatherLabel.font = [UIFont systemFontOfSize:12];
                nightWeatherLabel.text = self.weather._41img_title8;
                [self addSubview:nightWeatherLabel];
                break;
            }
            case 4:
            {
                UILabel *dayWeatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(vInterval-1)+5, 30, 40, 15)];
                [dayWeatherLabel setTextAlignment:UITextAlignmentCenter];
                [dayWeatherLabel setBackgroundColor:[UIColor clearColor]];
                [dayWeatherLabel setTextColor:[UIColor whiteColor]];
                dayWeatherLabel.numberOfLines = 1;
                dayWeatherLabel.adjustsFontSizeToFitWidth = YES;
                dayWeatherLabel.minimumFontSize = 1.0f;
                dayWeatherLabel.font = [UIFont systemFontOfSize:12];
                dayWeatherLabel.text = self.weather._42img_title9;
                [self addSubview:dayWeatherLabel];
                
                
                UILabel *nightWeatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(vInterval-1)+5, self.frame.size.height-50, 40, 15)];
                [nightWeatherLabel setTextAlignment:UITextAlignmentCenter];
                [nightWeatherLabel setBackgroundColor:[UIColor clearColor]];
                [nightWeatherLabel setTextColor:[UIColor whiteColor]];
                nightWeatherLabel.numberOfLines = 1;
                nightWeatherLabel.adjustsFontSizeToFitWidth = YES;
                nightWeatherLabel.minimumFontSize = 1.0f;
                nightWeatherLabel.font = [UIFont systemFontOfSize:12];
                nightWeatherLabel.text = self.weather._43img_title10;
                [self addSubview:nightWeatherLabel];
                break;
            }
            case 5:
            {
                UILabel *dayWeatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(vInterval-1)+5, 30, 40, 15)];
                [dayWeatherLabel setTextAlignment:UITextAlignmentCenter];
                [dayWeatherLabel setBackgroundColor:[UIColor clearColor]];
                [dayWeatherLabel setTextColor:[UIColor whiteColor]];
                dayWeatherLabel.numberOfLines = 1;
                dayWeatherLabel.adjustsFontSizeToFitWidth = YES;
                dayWeatherLabel.minimumFontSize = 1.0f;
                dayWeatherLabel.font = [UIFont systemFontOfSize:12];
                dayWeatherLabel.text = self.weather._44img_title11;
                [self addSubview:dayWeatherLabel];
                
                
                UILabel *nightWeatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(vInterval-1)+5, self.frame.size.height-50, 40, 15)];
                [nightWeatherLabel setTextAlignment:UITextAlignmentCenter];
                [nightWeatherLabel setBackgroundColor:[UIColor clearColor]];
                [nightWeatherLabel setTextColor:[UIColor whiteColor]];
                nightWeatherLabel.numberOfLines = 1;
                nightWeatherLabel.adjustsFontSizeToFitWidth = YES;
                nightWeatherLabel.minimumFontSize = 1.0f;
                nightWeatherLabel.font = [UIFont systemFontOfSize:12];
                nightWeatherLabel.text = self.weather._45img_title12;
                [self addSubview:nightWeatherLabel];
                break;
            }
            default:
                break;
        }
        
    }
    
    
    //画点线条------------------
    CGFloat pointLineWidth = 3.0f;
    
    CGContextSetLineWidth(context, pointLineWidth);//主线宽度
    CGContextSetStrokeColorWithColor(context, RGBCOLOR(96, 222, 246).CGColor);
	//绘图
    NSInteger count = [self.lowTempAry count];
    CGPoint graphPoints[count];
	for (int i = 0; i<[self.lowTempAry count]; i++)
	{
		CGPoint lowPoint = CGPointMake(vInterval*i + 23, [self compYPoint:((NSString *)[self.lowTempAry objectAtIndex:i]).intValue]);
		graphPoints[i] = lowPoint;
	}
    CGContextAddLines(context, graphPoints, count);
	CGContextStrokePath(context);
    // DISEGNO I CERCHI NEL GRANO
    for (int i = 0; i < [self.lowTempAry count]; ++i) {
        CGRect ellipseRect = CGRectMake(graphPoints[i].x-3, graphPoints[i].y-3, 6, 6);
        CGContextAddEllipseInRect(context, ellipseRect);
        CGContextSetLineWidth(context, 2);
        [[UIColor whiteColor] setStroke];
        [[UIColor yellowColor] setFill];
        CGContextFillEllipseInRect(context, ellipseRect);
        CGContextStrokeEllipseInRect(context, ellipseRect);
        
        UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(graphPoints[i].x-18, graphPoints[i].y+10, 40, 15)];
        [tempLabel setTextAlignment:UITextAlignmentCenter];
        [tempLabel setBackgroundColor:[UIColor clearColor]];
        [tempLabel setTextColor:[UIColor whiteColor]];
        tempLabel.numberOfLines = 1;
        tempLabel.adjustsFontSizeToFitWidth = YES;
        tempLabel.minimumFontSize = 1.0f;
        tempLabel.font = [UIFont systemFontOfSize:14];
        tempLabel.text = [NSString stringWithFormat:@"%@°",[self.lowTempAry objectAtIndex:i]];
        [self addSubview:tempLabel];
        
        switch (i) {
            case 0:
            {
                UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(graphPoints[i].x-18, graphPoints[i].y+25, 34, 34)];
                NSString *imageNumber = self.weather._23img2;
                if ([imageNumber isEqualToString:@"99"]) {
                    imageNumber = self.weather._22img1;
                }
                weatherImageView.backgroundColor = [UIColor clearColor];
                weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageNumber]];
                [self addSubview:weatherImageView];
                break;
            }
            case 1:
            {
                UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(graphPoints[i].x-18, graphPoints[i].y+25, 34, 34)];
                NSString *imageNumber = self.weather._25img4;
                if ([imageNumber isEqualToString:@"99"]) {
                    imageNumber = self.weather._24img3;
                }
                weatherImageView.backgroundColor = [UIColor clearColor];
                weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageNumber]];
                [self addSubview:weatherImageView];
                break;
            }
            case 2:
            {
                UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(graphPoints[i].x-18, graphPoints[i].y+25, 34, 34)];
                NSString *imageNumber = self.weather._27img6;
                if ([imageNumber isEqualToString:@"99"]) {
                    imageNumber = self.weather._26img5;
                }
                weatherImageView.backgroundColor = [UIColor clearColor];
                weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageNumber]];
                [self addSubview:weatherImageView];
                break;
            }
            case 3:
            {
                UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(graphPoints[i].x-18, graphPoints[i].y+25, 34, 34)];
                NSString *imageNumber = self.weather._29img8;
                if ([imageNumber isEqualToString:@"99"]) {
                    imageNumber = self.weather._28img7;
                }
                weatherImageView.backgroundColor = [UIColor clearColor];
                weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageNumber]];
                [self addSubview:weatherImageView];
                break;
            }
            case 4:
            {
                UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(graphPoints[i].x-18, graphPoints[i].y+25, 34, 34)];
                NSString *imageNumber = self.weather._31img10;
                if ([imageNumber isEqualToString:@"99"]) {
                    imageNumber = self.weather._30img9;
                }
                weatherImageView.backgroundColor = [UIColor clearColor];
                weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageNumber]];
                [self addSubview:weatherImageView];
                break;
            }
            case 5:
            {
                UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(graphPoints[i].x-18, graphPoints[i].y+25, 34, 34)];
                NSString *imageNumber = self.weather._33img12;
                if ([imageNumber isEqualToString:@"99"]) {
                    imageNumber = self.weather._32img11;
                }
                weatherImageView.backgroundColor = [UIColor clearColor];
                weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageNumber]];
                [self addSubview:weatherImageView];
                break;
            }
            default:
                break;
        }
        
    }
    
    CGContextSetLineWidth(context, pointLineWidth);//主线宽度
    CGContextSetStrokeColorWithColor(context, RGBCOLOR(255, 77, 118).CGColor);
    NSInteger highCount = [self.highTempAry count];
    CGPoint highGraphPoints[highCount];
    
    for (int i = 0; i<[self.highTempAry count]; i++)
	{
        CGPoint highPoint = CGPointMake(vInterval*i + 23, [self compYPoint:((NSString *)[self.highTempAry objectAtIndex:i]).intValue]);
		highGraphPoints[i] = highPoint;
	}
    CGContextAddLines(context, highGraphPoints, highCount);
    CGContextStrokePath(context);
    // DISEGNO I CERCHI NEL GRANO
    for (int i = 0; i < [self.highTempAry count]; ++i) {
        CGRect ellipseRect = CGRectMake(highGraphPoints[i].x-3, highGraphPoints[i].y-3, 6, 6);
        CGContextAddEllipseInRect(context, ellipseRect);
        CGContextSetLineWidth(context, 2);
        [[UIColor whiteColor] setStroke];
        [[UIColor yellowColor] setFill];
        CGContextFillEllipseInRect(context, ellipseRect);
        CGContextStrokeEllipseInRect(context, ellipseRect);
        
        
        UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(highGraphPoints[i].x-18, highGraphPoints[i].y-25, 40, 15)];
        [tempLabel setTextAlignment:UITextAlignmentCenter];
        [tempLabel setBackgroundColor:[UIColor clearColor]];
        [tempLabel setTextColor:[UIColor whiteColor]];
        tempLabel.numberOfLines = 1;
        tempLabel.adjustsFontSizeToFitWidth = YES;
        tempLabel.minimumFontSize = 1.0f;
        tempLabel.font = [UIFont systemFontOfSize:14];
        tempLabel.text = [NSString stringWithFormat:@"%@°",[self.highTempAry objectAtIndex:i]];
        [self addSubview:tempLabel];
        
        switch (i) {
            case 0:
            {
                UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(highGraphPoints[i].x-18, highGraphPoints[i].y-60, 34, 34)];
                
                weatherImageView.backgroundColor = [UIColor clearColor];
                weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.weather._22img1]];
                [self addSubview:weatherImageView];
                break;
            }
            case 1:
            {
                UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(highGraphPoints[i].x-18, highGraphPoints[i].y-60, 34, 34)];
                
                weatherImageView.backgroundColor = [UIColor clearColor];
                weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.weather._24img3]];
                [self addSubview:weatherImageView];
                break;
            }
            case 2:
            {
                UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(highGraphPoints[i].x-18, highGraphPoints[i].y-60, 34, 34)];
                
                weatherImageView.backgroundColor = [UIColor clearColor];
                weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.weather._26img5]];
                [self addSubview:weatherImageView];
                break;
            }
            case 3:
            {
                UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(highGraphPoints[i].x-18, highGraphPoints[i].y-60, 34, 34)];
                
                weatherImageView.backgroundColor = [UIColor clearColor];
                weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.weather._28img7]];
                [self addSubview:weatherImageView];
                break;
            }
            case 4:
            {
                UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(highGraphPoints[i].x-18, highGraphPoints[i].y-60, 34, 34)];
                
                weatherImageView.backgroundColor = [UIColor clearColor];
                weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.weather._30img9]];
                [self addSubview:weatherImageView];
                break;
            }
            case 5:
            {
                UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(highGraphPoints[i].x-18, highGraphPoints[i].y-60, 34, 34)];
                
                weatherImageView.backgroundColor = [UIColor clearColor];
                weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.weather._32img11]];
                [self addSubview:weatherImageView];
                break;
            }
            default:
                break;
        }
        
    }
    
}

- (void)btAction:(id)sender{
    [disLabel setText:@"100"];
    
    UIButton *bt = (UIButton*)sender;
    popView.center = CGPointMake(bt.center.x, bt.center.y - popView.frame.size.height/2);
    [popView setAlpha:1.0f];
}

- (void)initDayArray:(NSDate *) dateNow
{
    NSDateFormatter *tempformatter = [[NSDateFormatter alloc]init];
    [tempformatter setDateFormat:@"MM/dd"];
    for (int i=0; i < 6; i++) {
        NSString *dateString = [tempformatter stringFromDate:[dateNow dateByAddingTimeInterval:i*24*60*60]];
        [self.dateAryDesc addObject:dateString];
    }
}

- (void)initWeekArray:(NSDate *) dateNow
{
    [self.weekAryDesc addObject:@"今天"];
    for (int i=1; i < 6; i++) {
        NSString *weekString = [self getCNWeek:[dateNow dateByAddingTimeInterval:i*24*60*60]];
        [self.weekAryDesc addObject:weekString];
    }
}

- (NSString *)getCNWeek:(NSDate *)nsDate
{
    const unsigned int weekday = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:nsDate];
    NSString *cnWeek = @"";
    switch (weekday)
    {
        case 1:
        {   cnWeek = @"周日"; break;  }
        case 2:
        {   cnWeek = @"周一"; break;  }
        case 3:
        {   cnWeek = @"周二"; break;  }
        case 4:
        {   cnWeek = @"周三"; break;  }
        case 5:
        {   cnWeek = @"周四"; break;  }
        case 6:
        {   cnWeek = @"周五"; break;  }
        case 7:
        {   cnWeek = @"周六"; break;  }
    }
    
    return cnWeek;
}

- (void)convertTempToArray:(NSString *) temp
{
    if (temp != nil && ![temp isEqualToString:@""]) {
        NSArray *tempArray = [temp componentsSeparatedByString:@"~"];
        NSString *temp1 = tempArray[0];
        NSString *temp2 = tempArray[1];
        NSRange range1 = [temp1 rangeOfString:@"℃"];
        NSRange range2 = [temp2 rangeOfString:@"℃"];
        [self.lowTempAry addObject:[temp1 substringToIndex:(range1.location)]];
        [self.highTempAry addObject:[temp2 substringToIndex:(range2.location)]];
    }
}

- (float)compYPoint:(int) temp
{
    float centerY = 190;
    
    int sumTemp = 0;
    for (int i=0; i<self.lowTempAry.count; i++) {
        sumTemp += ((NSString *)[self.lowTempAry objectAtIndex:i]).intValue;
        sumTemp += ((NSString *)[self.highTempAry objectAtIndex:i]).intValue;
    }
    int averageTemp = sumTemp/12;
    
    int pointY = (centerY -(temp-averageTemp)*8);
    
    return pointY;
}

@end
