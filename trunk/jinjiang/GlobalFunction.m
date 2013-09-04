//
//  GlobalFunction.m
//  chengguo
//
//  Created by Jeff.Yan on 11-4-23.
//  Copyright 2011年 W+K. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import <CoreGraphics/CoreGraphics.h>

#import "GlobalFunction.h"


#import "LoadingView.h"



#import "RootWindowUI.h"


static UIColor *txtColor=nil;

@implementation GlobalFunction


+(void)getPropertyWithString:(id)object property:(NSString *)property value:(void *)value{
    SEL getter=NSSelectorFromString(property);
    NSMethodSignature *methodSignature=[[object class] instanceMethodSignatureForSelector:getter];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:object];
    [invocation setSelector:getter];
    [invocation invoke];
    [invocation getReturnValue:value];
}

+(void)setPropertyWithString:(id)object property:(NSString *)property value:(void *)value{
    SEL setter=NSSelectorFromString([NSString stringWithFormat:@"set%@:", [property stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[property substringToIndex:1] capitalizedString]]]);
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[object class]instanceMethodSignatureForSelector:setter]];
    [invocation setTarget:object];
    [invocation setSelector:setter];
    [invocation setArgument:value atIndex:2];
    [invocation invoke];
}

+(void)setTxtColor:(UIColor *)c{
    if(txtColor!=nil){
        [txtColor release];
    }
    txtColor=[c retain];
}
+(UIColor *)getTxtColor{
    if(txtColor==nil){
        txtColor=[[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] retain];
    }
    return txtColor;
}
+(void)logSubviews:(UIView *)view{
    for(NSInteger i=0;i<[view.subviews count];i++) {
        //NSLog(@"logSubviews:%@",[view.subviews objectAtIndex:i]);
    }
}
+(void)removeViews:(NSArray *)arr{
    for(NSInteger i=0;i<[arr count] ;i++){
        UIView *tem=(UIView*)[arr objectAtIndex:i];
        if(tem && tem.superview){
            [tem removeFromSuperview];
        }
    }
}

+(void)removeSubviews:(UIView *)view{
    while ([view.subviews count]>0) {
        [[view.subviews objectAtIndex:0] removeFromSuperview];
    }
}
+(void)addImage:(UIView *)view name:(NSString *)name{
    UIImageView  *uv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    [view addSubview:uv];
    [uv release];
}


+(void)addImage:(UIView *)view name:(NSString *)name rect:(CGRect)rect{
    UIImageView  *uv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    [uv setFrame:rect];
    [view addSubview:uv];
    [uv release];
}
+(void)addImage:(UIView *)view name:(NSString *)name point:(CGPoint)point{
    UIImageView  *uv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    [uv setFrame:CGRectMake(point.x, point.y, uv.frame.size.width, uv.frame.size.height)];
    [view addSubview:uv];
    [uv release];
}

+(void)addImage:(UIView *)view name:(NSString *)name rect:(CGRect)rect atIndex:(NSInteger)index{
    UIImageView  *uv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    [uv setFrame:rect];
    [view insertSubview:uv atIndex:index];
    [uv release];
}


+(void)closeTouch{
    [[RootWindowUI sharedInstance] closeTouch];
}

+(NSArray *)checkArr:(id)str{
    if([str isKindOfClass:[NSArray class]]){
        return str;
    }else{
        return nil;
    }
    
}

+(BOOL)checkIsNull:(NSString *)str{
    
    if(str==nil){
        return YES;
    }
    if([str isKindOfClass:[NSNull class]]){
        return YES;
    }
    if([str isEqualToString:@""]){
        return YES;
    }
    if([str isEqualToString:@"null"]){
        return YES;
    }
    if([str isEqualToString:@"NULL"]){
        return YES;
    }
    if([str isEqualToString:@"Null"]){
        return YES;
    }
    
    return NO;
}
+(void)fadeInOut:(UIView *)view to:(CGFloat)alpha time:(CGFloat)time delay:(CGFloat)delay hide:(BOOL)hide{
    
    // 动画开始
    [UIView beginAnimations:nil context:nil];
    
    // 动画时间曲线 EaseInOut效果
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; 
    
    // 动画时间
    
    [UIView setAnimationDuration:time];
    [UIView setAnimationDelay:delay];
    view.alpha=alpha;
    
    if(hide){
        [UIView setAnimationDidStopSelector: @selector(removeFromSuperview)];
        [UIView setAnimationDelegate:view];
    }
    
    
    
    // 动画结束（或者用提交也不错）
    
    [UIView commitAnimations];
    
}
+(void)fadeInOut:(UIView *)view to:(CGFloat)alpha time:(CGFloat)time hide:(BOOL)hide{
    
    // 动画开始
    [UIView beginAnimations:nil context:nil];
    
    // 动画时间曲线 EaseInOut效果
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; 
    
    // 动画时间
    
    [UIView setAnimationDuration:time];
    
    view.alpha=alpha;
    
    if(hide){
        [UIView setAnimationDidStopSelector: @selector(removeFromSuperview)];
        [UIView setAnimationDelegate:view];
    }
    
    
    
    // 动画结束（或者用提交也不错）
    
    [UIView commitAnimations];
    
}
+(void)fadeInOut:(UIView *)view to:(CGFloat)alpha time:(CGFloat)time target:(id)target action:(SEL)action {
    
    // 动画开始
    [UIView beginAnimations:nil context:nil];
    
    // 动画时间曲线 EaseInOut效果
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; 
    
    // 动画时间
    
    [UIView setAnimationDuration:time];
    
    view.alpha=alpha;
    
    
    [UIView setAnimationDidStopSelector: action];
    [UIView setAnimationDelegate:target];
    
    
    
    // 动画结束（或者用提交也不错）
    
    [UIView commitAnimations];
    
}

+(void)scaleView:(UIView *)view to:(CGFloat)zoom time:(float)time{
    
    CGAffineTransform transform = view.transform;   
    
    transform = CGAffineTransformScale(transform, zoom,zoom);
    
    // 动画开始
    [UIView beginAnimations:nil context:nil];
    
    // 动画时间曲线 EaseInOut效果
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; 
    
    // 动画时间
    
    [UIView setAnimationDuration:time];
    
    view.transform = transform;
    
    
    // 动画结束（或者用提交也不错）
    
    [UIView commitAnimations];
}
+(void)scaleView:(UIView *)view to:(CGFloat)zoom time:(float)time target:(id)target action:(SEL)action {
    
    CGAffineTransform transform = view.transform;   
    
    transform = CGAffineTransformScale(transform, zoom,zoom);
    
    // 动画开始
    [UIView beginAnimations:nil context:nil];
    
    // 动画时间曲线 EaseInOut效果
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; 
    
    // 动画时间
    
    [UIView setAnimationDuration:time];
    
    view.transform = transform;
    
    
    // 动画结束（或者用提交也不错）
    [UIView setAnimationDidStopSelector: action];
    [UIView setAnimationDelegate:target];
    
    
    
    [UIView commitAnimations];
}
+(void)rotateScaleView:(UIView *)view angle:(CGFloat)angle  zoom:(CGFloat)zoom time:(float)time  target:(id)target action:(SEL)action delay:(CGFloat)delay{
    
    CGAffineTransform transform = view.transform;   
    
    transform = CGAffineTransformRotate(transform, angle);
    transform = CGAffineTransformScale(transform, zoom,zoom);
    // 动画开始
    [UIView beginAnimations:nil context:nil];
    
    // 动画时间曲线 EaseInOut效果
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; 
    
    // 动画时间
    
    [UIView setAnimationDuration:time];
    
    [UIView setAnimationDelay:delay];
    /////////////////////////////
    [UIView setAnimationsEnabled:YES];
    
    view.transform = transform;
    // 动画结束（或者用提交也不错）
    [UIView setAnimationDidStopSelector: action];
    [UIView setAnimationDelegate:target];
    
    [UIView commitAnimations];
}
+(void)rotateView:(UIView *)view to:(CGFloat)angle time:(float)time{
    
    CGAffineTransform transform = view.transform;   
    
    transform = CGAffineTransformRotate(transform, angle);
    if(time>0.0){
        // 动画开始
        [UIView beginAnimations:nil context:nil];
        
        // 动画时间曲线 EaseInOut效果
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; 
        
        // 动画时间
        
        [UIView setAnimationDuration:time];
        
        view.transform = transform;
        
        
        // 动画结束（或者用提交也不错）
        
        [UIView commitAnimations];
    }else{
        view.transform = transform;
    }
}

+(void)rotateView:(UIView *)view to:(CGFloat)angle time:(float)time target:(id)target action:(SEL)action {
    
    CGAffineTransform transform = view.transform;   
    
    transform = CGAffineTransformRotate(transform, angle);
    
    // 动画开始
    [UIView beginAnimations:nil context:nil];
    
    // 动画时间曲线 EaseInOut效果
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; 
    
    // 动画时间
    
    [UIView setAnimationDuration:time];
    
    view.transform = transform;
    
    
    // 动画结束（或者用提交也不错）
    [UIView setAnimationDidStopSelector: action];
    [UIView setAnimationDelegate:target];
    
    [UIView commitAnimations];
}

+(void)moveView:(UIView *)view to:(CGRect)frame time:(float)time{
    
    // 动画开始
    [UIView beginAnimations:nil context:nil];
    
    // 动画时间曲线 EaseInOut效果
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; 
    
    // 动画时间
    
    [UIView setAnimationDuration:time];
    
    view.frame = frame;
    
    
    // 动画结束（或者用提交也不错）
    
    [UIView commitAnimations];
}
+(void)moveView:(UIView *)view to:(CGRect)frame time:(float)time  target:(id)target action:(SEL)action {
    
    // 动画开始
    [UIView beginAnimations:nil context:nil];
    
    // 动画时间曲线 EaseInOut效果
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; 
    
    // 动画时间
    
    [UIView setAnimationDuration:time];
    
    view.frame = frame;
    
    // 动画结束（或者用提交也不错）
    [UIView setAnimationDidStopSelector: action];
    [UIView setAnimationDelegate:target];
    
    
    [UIView commitAnimations];
}
//返回一個等比縮放的image
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+(UIImage *)reScaleSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    float scaleSize1=reSize.width/image.size.width;
    float scaleSize2=reSize.height/image.size.height;
    float scaleSize=scaleSize1>scaleSize2?scaleSize1:scaleSize2;
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
//返回一個自定size的image
+(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

//animtimer = [NSTimer scheduledTimerWithTimeInterval:frameTime target:self selector:@selector(updateFrame) userInfo:nil repeats:YES];

// return image with shadow
+ (UIImage *)shadowImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.6].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
    UIImage *subImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return subImage;
}

// add pause to image
+ (UIImage *)startDownloadImage:(UIImage *)image
{
    return [GlobalFunction combineImage:image withText:@"点击下载"];
}

// add pause to image
+ (UIImage *)pauseImage:(UIImage *)image
{
    return [GlobalFunction combineImage:image withText:@"暂  停"];
}

// add fail to image
+ (UIImage *)downloadImage:(UIImage *)image
{
    return [GlobalFunction combineImage:image withText:@"下载中"];
}

// add fail to image
+ (UIImage *)failImage:(UIImage *)image
{
    return [GlobalFunction combineImage:image withText:@"下载失败"];
}

+ (UIImage *)combineImage:(UIImage *)firstImage withImage:(UIImage *)secondImage inRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(firstImage.size);
    [firstImage drawInRect:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    [secondImage drawInRect:rect];
    UIImage *subImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return subImage;
}

+ (UIImage *)combineImage:(UIImage *)image withProgress:(UIImage *)progressImage
{
    CGRect rect = CGRectMake((image.size.width-progressImage.size.width)/2, image.size.height-113, progressImage.size.width, progressImage.size.height);
    return [GlobalFunction combineImage:image withImage:progressImage inRect:rect];
}

+ (UIImage *)combineImage:(UIImage *)firstImage withText:(NSString *)text inRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(firstImage.size);
    [firstImage drawInRect:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [text drawInRect:rect withFont:[UIFont boldSystemFontOfSize:25] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    UIImage *subImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return subImage;
}

+ (UIImage *)combineImage:(UIImage *)image withText:(NSString *)text
{
    CGRect rect = CGRectMake(0, image.size.height-163, image.size.width, 50);
    return [GlobalFunction combineImage:image withText:text inRect:rect];
}

+(UIColor *)getColor:(int)type{
    switch (type) {
        case 0:
            // //d9d9d9 0.85f  0.9
            //框灰
            return ([UIColor colorWithRed:0.85f green:0.85f blue:0.85f alpha:1.0f]);
            break;
        case 1:
            //框内灰
            return ([UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]);
            break;
        case 2:
            //
            return ([UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]);
            break;
        case 3:
            
            //黄色 f7f8d0
            return ([UIColor colorWithRed:0.9686274509803922f green:0.9725490196078431f blue:0.8156862745098039f alpha:1.0f]);
            break;
        case 4:
            //红色 800019 128
            return ([UIColor colorWithRed:0.5f green:0.0f blue:0.098f alpha:1.0f]);
            break;
            //800019
        case 5:
            //灰色 7a7a7a
            return ([UIColor colorWithRed:0.478f green:0.478f blue:0.478f alpha:1.0f]);
            break;
        case 6:
            //黑色 7a7a7a
            return ([UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]);
            break;
        case 7:
            //白色 7a7a7a
            return ([UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]);
            break;
        case 8:
            //淡黄 f4f5e7   ::::
            return ([UIColor colorWithRed:0.9568627450980393 green:0.9607843137254902 blue:0.9058823529411765 alpha:1.0f]);
            break;
        case 9:
            //深灰 0x3333333 
            return ([UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:0.3f]);
            break;
        case 10:
            //透明灰 0x3333333 
            return ([UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f]);
            break;
            //
        default:
            
            break;
    }
    return ([UIColor whiteColor]);
}






/*
 +(id)initLabelLeft:(NSString *)copy frame:(CGRect)frame size:(CGFloat)size{
 
 return [GlobalFunction initLabelLeft:copy frame:frame size:size lines:0];
 }
 
 +(id)initLabelLeft:(NSString *)copy frame:(CGRect)frame size:(CGFloat)size lines:(NSInteger) lines{
 //NSLog(@"::::titleTxt2::%@",[GlobalFunction getTxtColor]);
 UILabel *ul=[[UILabel alloc] initWithFrame:frame];
 ul.backgroundColor=[UIColor clearColor];
 ul.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:size];
 ul.textColor = [GlobalFunction getTxtColor];
 ul.numberOfLines=lines;
 ul.text=copy;
 ul.userInteractionEnabled=NO;
 return ul;
 //[uv addSubview:ul];
 //[ul release];
 }
 */

+ (UIImage*)imageFromView:(UIView*)view frame:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, view.layer.contentsScale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
+(UIImage *)glToUIImage:(UIView*)view{
    
    
    CGRect rect=view.bounds;
    NSInteger xx=rect.size.width;
    NSInteger yy=rect.size.height;
    
    NSInteger myDataLength = xx * yy * 4;
    
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, xx, yy, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    
    NSInteger xx2=xx*4;
    // 
    NSInteger hh=yy-1;
    for(int y = 0; y <yy; y++)
    {
        for(int x = 0; x <xx2; x++)
        {
            buffer2[(hh - y) * xx + x] = buffer[y * xx2 + x];
        }
    }
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * xx;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(xx, yy, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    return myImage;
}

+ (UIImage*)imageFromView:(UIView*)view{
    UIGraphicsBeginImageContext(view.frame.size);
    
    //UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.layer.contentsScale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}


+(void)addLabelLeft:(UIView *)uv copy:(NSString *)copy frame:(CGRect)frame size:(CGFloat)size{
    [GlobalFunction addLabelLeft:uv copy:copy frame:frame size:size lines:0];
}

+(void)addLabelLeft:(UIView *)uv copy:(NSString *)copy frame:(CGRect)frame size:(CGFloat)size lines:(NSInteger) lines{
    UILabel *ul=[[UILabel alloc] initWithFrame:frame];
    ul.backgroundColor=[UIColor clearColor];
    ul.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:size];
    ul.textColor = [GlobalFunction getTxtColor];
    ul.numberOfLines=lines;
    ul.text=copy;
    ul.userInteractionEnabled=NO;
    [uv addSubview:ul];
    [ul release];
}

+(void)addLabelCenter:(UIView *)uv copy:(NSString *)copy frame:(CGRect)frame size:(CGFloat)size{
    UILabel *ul=[[UILabel alloc] initWithFrame:frame];
    ul.textAlignment=UITextAlignmentCenter;
    ul.backgroundColor=[GlobalFunction getTxtColor];
    ul.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:size];
    ul.textColor = [UIColor whiteColor];
    
    ul.text=copy;
    [uv addSubview:ul];
    [ul release];
}



+(UIImage *)getImageFromImage:(UIImage*)superImage rect:(CGRect)rect
{
    CGSize subImageSize = CGSizeMake(rect.size.width, rect.size.height);
    //定义裁剪的区域相对于原图片的位置
    CGRect subImageRect = rect;
    CGImageRef imageRef = superImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    //
    CGImageRelease(subImageRef);
    //返回裁剪的部分图像
    return subImage;
    
}


+(UIImage*) createWireFrmaeImage:(CGFloat)wd ht:(CGFloat)ht r:(CGFloat)r  cr:(CGFloat)cr cg:(CGFloat)cg cb:(CGFloat)cb ca:(CGFloat)ca{
    CGContextRef myContext = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    NSInteger       bitmapByteCount;
    NSInteger       bitmapBytesPerRow;
    
    //声明一个变量来代表每行的字节数。每一个位图像素的代表是4个字节，8bit红，8bit绿，8bit蓝，和8bit alpha通道信息(透明信息)。
    bitmapBytesPerRow   = (wd * 4);
    bitmapByteCount     = (bitmapBytesPerRow * ht);
    colorSpace = CGColorSpaceCreateDeviceRGB();// 创建一个通用的RGB色彩空间
    bitmapData = malloc( bitmapByteCount );// 调用的malloc函数来创建的内存用来存储位图数据块
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease( colorSpace );
        //fprintf (stderr, "Memory not allocated!");
        return NULL;
    }
    
    //创建一个位图图形上下文
    myContext = CGBitmapContextCreate (bitmapData,
                                       wd,
                                       ht,
                                       8,      // bits per component
                                       bitmapBytesPerRow,
                                       colorSpace,
                                       kCGImageAlphaPremultipliedLast);
    if (myContext== NULL)
    {
        CGColorSpaceRelease( colorSpace );
        free (bitmapData);
        fprintf (stderr, "Context not created!");
        return NULL;
    }
    //释放colorSpace 注意使用的函数
    
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path,nil,CGRectMake(0, 0, wd, r));
    CGPathAddRect(path,nil,CGRectMake(0, ht-r, wd, r));
    CGPathAddRect(path,nil,CGRectMake(0, r, r, ht-r-r));
    CGPathAddRect(path,nil,CGRectMake(wd-r, r, r, ht-r-r));
    //画矩形
    //CGPathMoveToPoint(path, NULL,0, 0);
    //CGPathAddArcToPoint(path, NULL, 0,0+ht, ox+r,oy+rh, r);
    //CGPathAddArcToPoint(path, NULL, ox+rw, oy+rh, ox+rw, oy+rh-r, r);
    //CGPathAddArcToPoint(path, NULL, ox+rw, oy, ox+rw-r, oy, r);
    //CGPathAddArcToPoint(path, NULL, ox, oy, ox,oy+r,r);
    
    //填充矩形内部颜色
    CGContextAddPath(myContext,path);
    CGContextSetFillColorSpace(myContext, colorSpace);
    CGFloat zFillColour1[4]    = {cr/255, cg/255.0, cb/255.0, ca};
    CGContextSetFillColor(myContext, zFillColour1);
    CGContextEOFillPath(myContext);
    //生成图像
    CGImageRef myImage = CGBitmapContextCreateImage (myContext);
    UIImage * image = [UIImage imageWithCGImage:myImage];
    
    CGPathRelease(path);
    CGColorSpaceRelease( colorSpace );
    CGContextRelease(myContext);
    CGImageRelease(myImage);
    return image;
}

/////////////////

CGContextRef MyCreateBitmapContext (int pixelsWide,
                                    int pixelsHigh)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    //声明一个变量来代表每行的字节数。每一个位图像素的代表是4个字节，8bit红，8bit绿，8bit蓝，和8bit alpha通道信息(透明信息)。
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateDeviceRGB();// 创建一个通用的RGB色彩空间
    bitmapData = malloc( bitmapByteCount );// 调用的malloc函数来创建的内存用来存储位图数据块
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease( colorSpace );
        fprintf (stderr, "Memory not allocated!");
        return NULL;
    }
    
    //创建一个位图图形上下文
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    if (context== NULL)
    {
        CGColorSpaceRelease( colorSpace );
        free (bitmapData);
        fprintf (stderr, "Context not created!");
        return NULL;
    }
    //释放colorSpace 注意使用的函数
    CGColorSpaceRelease( colorSpace );
    return context;
}

/*
 生成一个聊天的对话框背景图
 参数
 myContext:一个图形上下文
 ox: 矩形左下角x坐标
 oy: 矩形左下角y坐标
 rw: 矩形宽度
 rh: 矩形高度
 r : 矩形圆角半径
 Orientation: 箭头方向，0-7 
 */
UIImage* createDialogBox (CGContextRef myContext, float ox, float oy, float rw, float rh, float r,  int Orientation)
{
    CGMutablePathRef path = CGPathCreateMutable();
    //画矩形
    CGPathMoveToPoint(path, NULL,ox, oy+r);
    CGPathAddArcToPoint(path, NULL, ox, oy+rh, ox+r,oy+rh, r);
    CGPathAddArcToPoint(path, NULL, ox+rw, oy+rh, ox+rw, oy+rh-r, r);
    CGPathAddArcToPoint(path, NULL, ox+rw, oy, ox+rw-r, oy, r);
    CGPathAddArcToPoint(path, NULL, ox, oy, ox,oy+r,r);
    //画箭头
    switch (Orientation) {
        case 0:
            CGPathMoveToPoint(path, NULL,ox+r+10.0, oy+rh);
            CGPathAddLineToPoint(path, NULL, ox+r+10.0, oy+rh+20);
            CGPathAddLineToPoint(path, NULL, ox+r+30.0, oy+rh);
            break;
        case 1:
            CGPathMoveToPoint(path, NULL,ox+rw-r-10.0, oy+rh);
            CGPathAddLineToPoint(path, NULL, ox+rw-r-10.0, oy+rh+20);
            CGPathAddLineToPoint(path, NULL, ox+rw-r-30.0, oy+rh);
            break;
        case 2:
            CGPathMoveToPoint(path, NULL,ox+rw, oy+rh-r-10);
            CGPathAddLineToPoint(path, NULL, ox+rw+20, oy+rh-r-10);
            CGPathAddLineToPoint(path, NULL, ox+rw, oy+rh-r-30);
            break;
        case 3:
            CGPathMoveToPoint(path, NULL,ox+rw, oy+r+10);
            CGPathAddLineToPoint(path, NULL, ox+rw+20, oy+r+10);
            CGPathAddLineToPoint(path, NULL, ox+rw, oy+r+30);
            break;
        case 4:
            CGPathMoveToPoint(path, NULL,ox+rw-r-10.0, oy);
            CGPathAddLineToPoint(path, NULL, ox+rw-r-10.0, oy-20);
            CGPathAddLineToPoint(path, NULL, ox+rw-r-30.0, oy);
            break;
        case 5:
            CGPathMoveToPoint(path, NULL,ox+r+10.0, oy);
            CGPathAddLineToPoint(path, NULL, ox+r+10.0, oy-20);
            CGPathAddLineToPoint(path, NULL, ox+r+30.0, oy);
            break;
        case 6:
            CGPathMoveToPoint(path, NULL,ox, oy+r+10);
            CGPathAddLineToPoint(path, NULL, ox-20, oy+r+10);
            CGPathAddLineToPoint(path, NULL, ox, oy+r+30);
            break;
        case 7:
            CGPathMoveToPoint(path, NULL,ox, oy+rh-r-10);
            CGPathAddLineToPoint(path, NULL, ox-20, oy+rh-r-10);
            CGPathAddLineToPoint(path, NULL, ox, oy+rh-r-30);
            break;
        default:
            break;
    }
    //描边 以及添加阴影效果
    CGColorSpaceRef colorSpaceRef;
    colorSpaceRef=CGColorSpaceCreateDeviceRGB();
    
    
    CGContextSetLineJoin(myContext, kCGLineJoinRound);
    CGFloat zStrokeColour[4]    = {180.0/255, 180.0/255.0, 180.0/255.0, 1.0};
    CGContextSetLineWidth(myContext, 13.0);
    CGContextAddPath(myContext,path);
    
    CGContextSetStrokeColorSpace(myContext, colorSpaceRef);
    
    CGContextSetStrokeColor(myContext, zStrokeColour);
    CGContextStrokePath(myContext);
    CGSize myShadowOffset = CGSizeMake (0,  0);
    CGContextSaveGState(myContext);
    
    CGContextSetShadow (myContext, myShadowOffset, 5);
    CGContextSetLineJoin(myContext, kCGLineJoinRound);
    CGFloat zStrokeColour1[4]    = {228.0/255, 168.0/255.0, 81.0/255.0, 1.0};
    CGContextSetLineWidth(myContext, 3.0);
    CGContextAddPath(myContext,path);
    
    
    CGContextSetStrokeColorSpace(myContext,colorSpaceRef);
    
    
    
    CGContextSetStrokeColor(myContext, zStrokeColour1);
    CGContextStrokePath(myContext);
    CGContextRestoreGState(myContext);
    //填充矩形内部颜色
    CGContextAddPath(myContext,path);
    
    
    
    CGContextSetFillColorSpace(myContext, colorSpaceRef);
    
    
    
    CGFloat zFillColour1[4]    = {229.0/255, 229.0/255.0, 231.0/255.0, 1};
    CGContextSetFillColor(myContext, zFillColour1);
    CGContextEOFillPath(myContext);
    //生成图像
    CGImageRef myImage = CGBitmapContextCreateImage (myContext);
    UIImage * image = [UIImage imageWithCGImage:myImage];
    
    CGPathRelease(path);
    
    CGColorSpaceRelease(colorSpaceRef);
    
    CGContextRelease(myContext);
    CGImageRelease(myImage);
    return image;
}

/////////////////time

+(void)randomArray:(NSMutableArray *)arr{
    NSMutableArray *tem=[[NSMutableArray alloc] initWithArray:arr];
    NSObject *obj;
    NSInteger ran;
    [arr removeAllObjects];
    while([tem count]>0){
        ran=floor((CGFloat)rand()/RAND_MAX*(CGFloat)[tem count]);
        obj=[[tem objectAtIndex:ran] retain];
        [tem removeObjectAtIndex:ran];
        [arr addObject:obj];
        [obj release];
    }
    [tem release];
    
}

@end
