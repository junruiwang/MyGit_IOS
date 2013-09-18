//
//  ViewController.m
//  CGAffineTransformDemo
//
//  Created by jerry on 13-9-18.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//缩放
- (void)animateWithViewScale
{
    //缩放，宽度变为原始值的0.01，高度不变
    CGAffineTransform imageTransform = CGAffineTransformMakeScale(0.01, 1.0);
    [UIView animateWithDuration:0.4 animations:^{
        self.cardView.transform = imageTransform;
    } completion:^(BOOL finished){
        self.cardView.image = [UIImage imageNamed:@"membercard_yuexiang"];
        [UIView animateWithDuration:0.4 animations:^{
            self.cardView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            
        }];
    }];
}

//旋转
- (void)animateWithViewRotation
{
    [UIView animateWithDuration:0.4 animations:^{
        self.cardView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:2.0 animations:^{
            self.cardView.transform = CGAffineTransformMakeRotation(M_PI_2);
        } completion:^(BOOL isFinished){
            [UIView animateWithDuration:0.4 animations:^{
                self.cardView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                
            }];
        }];
    }];
    
}

//移动、旋转
- (void)animateWithViewTranslation
{    

    //参数1 X轴坐标的偏移；参数2 Y轴坐标的偏移
    
    [UIView animateWithDuration:2.0 animations:^{
        self.cardView.transform = CGAffineTransformRotate(self.cardView.transform, M_PI_2);
    } completion:^(BOOL finished){
        
    }];
    
    [UIView animateWithDuration:2.0 animations:^{
        self.cardView.transform = CGAffineTransformMakeTranslation(0, 300);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.4 animations:^{
            self.cardView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            
        }];
    }];
    
    
    
}

- (IBAction)buttonClicked:(id)sender
{
    [self animateWithViewTranslation];
}

@end
