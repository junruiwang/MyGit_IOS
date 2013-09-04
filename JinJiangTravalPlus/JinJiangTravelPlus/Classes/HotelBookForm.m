//
//  HotelBookForm.m
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 12/6/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "HotelBookForm.h"
#import "ValidateInputUtil.h"

@implementation HotelBookForm


-(BOOL)verify{
    if(![ValidateInputUtil isNotEmpty:_checkInPersonName fieldCName:@"入住人"]){
        return NO;
    }
    if (![ValidateInputUtil isEffectGuestNames:_checkInPersonName guestCount:self.roomCount]) {
        return NO;
    }
    
    if(![ValidateInputUtil isNotEmpty:_contactPersonName fieldCName:@"联系人"])
        return NO;
    
//    if(![ValidateInputUtil isEffectivePhone:_contactPersonMobile])
//        return NO;
    if(![ValidateInputUtil isNotEmpty:_orderType fieldCName:@"支付类型"])
        return NO;
    
    return YES;
}


@end
