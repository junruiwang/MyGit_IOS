//
//  JYTween.h
//  jinjiang
//
//  Created by Jeff.Yan on 11-11-24.
//  Copyright 2011年 W+K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYTweenObject.h"

@interface JYTween : NSObject {
    
}
+(JYTweenObject *)addTween:(id) to:(CGFloat)value time:(CGFloat)time getSel:(SEL)getSel setSel:(SEL)setSel delay:(CGFloat)delay;
+(JYTweenObject *)addTween:(id) to:(CGFloat)value time:(CGFloat)time getSel:(SEL)getSel setSel:(SEL)setSel delay:(CGFloat)delay startSel:(SEL)startSel updateSel:(SEL)updateSel endSel:(SEL)endSel;

@end
