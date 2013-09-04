//
//  PaymentController.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/31/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnionPaymentParser.h"
#import "UnionPaymentResult.h"

@protocol PayControllerDelegate <NSObject>

-(void)applySuccessProcess;

-(void)applyFailProcess;

@end

@interface PayController : NSObject <GDataXMLParserDelegate>

@property (nonatomic,strong) UnionPaymentParser *unionPaymentParser;

@property (nonatomic,weak) id<PayControllerDelegate> delegate;

@end
