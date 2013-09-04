//
//  ShakeAwardViewController.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 5/21/13.
//  Copyright (c) 2013 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShakeAwardViewController : JJViewController<GDataXMLParserDelegate>

@property(nonatomic,weak) IBOutlet UIImageView *shakeMobileImgView;

@property(nonatomic,weak) IBOutlet UIImageView *shakeShadawImgView;

@property(nonatomic,weak) IBOutlet UIImageView *mobileShadawImgView;

@property(nonatomic,weak) IBOutlet UIImageView *ribbonBgImgView;

@property(nonatomic,weak) IBOutlet UIImageView *actionRuleBgImgView;

@property(nonatomic,weak) IBOutlet UILabel *actionLabel;

@property(nonatomic,weak) IBOutlet UIImageView *shakeSymbolLeft;

@property(nonatomic,weak) IBOutlet UIImageView *shakeSymbolRight;

@property(nonatomic,weak) IBOutlet UIButton *okBtn;

@property(nonatomic,weak) IBOutlet UIView *awardResultView;

@property(nonatomic,weak) IBOutlet UIImageView *getAwardImgView;

@property(nonatomic,weak) IBOutlet UIImageView *notAwardImgView;

@property(nonatomic,weak) IBOutlet UILabel *awardResultTextLabel;

@property(nonatomic,weak) IBOutlet UILabel *awardDescTextLabel;

-(IBAction)clickRestoreShakeView:(id)sender;

@end
