//
//  OrderCancelView.h
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 12-12-27.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCancelParser.h"

@class OrderCancelView;

@protocol OrderCancelViewDelegate <NSObject>

- (void)orderCancelView:(OrderCancelView*)orderCancelView willCancelOrder:(NSString*)message;
- (void)orderCancelView:(OrderCancelView*)orderCancelView didCancelOrder:(NSString*)message;
- (void)orderCancelView:(OrderCancelView*)orderCancelView didReturnToController:(NSString*)orderNo;

@end

@interface OrderCancelView : UIView<GDataXMLParserDelegate>
{
    unsigned int selectedReason;
}

@property(nonatomic, strong)NSString* orderNo;
@property(nonatomic, strong)NSString* orderID;
@property(nonatomic, strong)NSString *cancelPolicyText;
@property(nonatomic, strong)UITextView* otherReason;
@property(nonatomic, strong)UIButton* closeBtn;
@property(nonatomic, strong)UIButton* cancelBtn;
@property(nonatomic, strong)UIButton* backBtn;
@property(nonatomic, strong)UIButton* btn5;
@property(nonatomic, weak)id<OrderCancelViewDelegate> delegate;
@property(nonatomic, strong)OrderCancelParser* orderCancelParser;
@property(nonatomic, strong)UITextView *cancelPolicyDescLabel;

- (void)cancelOrder:(NSString*)orderNumber;
- (void)selectReason:(id)sender;
- (void)returnButtonClicked:(id)sender;
- (void)cancelButtonClicked:(id)sender;

- (void)uiKeyboardWillShow:(NSNotification*)notification;
- (void)uiKeyboardWillHide:(NSNotification*)notification;

@end
