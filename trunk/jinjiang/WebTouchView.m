//
//  WebTouchView.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-29.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "WebTouchView.h"
#import "TouchPointObj.h"
#import "MainNC.h"

@implementation WebTouchView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [(UIScrollView *)[[self subviews] objectAtIndex:0] setBounces:NO];
        self.backgroundColor = [UIColor whiteColor];
        //self.delegate=self;
    }
    return self;
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL{
 //   NSString *newHTMLString=[string stringByAppendingString:@"<script language=\"javascript\">var anObject ={handleEvent: function(e){switch(e.type){case \"touchstart\":var str=\"myweb:touch:start:\";for(var i=0;i<e.touches.length;i++){if(i>0){str+=\"-\";}str+=e.touches[i].identifier+\",\"+e.touches[i].screenX+\",\"+e.touches[i].screenY;}document.location=str+\":\"+new Date().getTime();break;case \"touchmove\":var str=\"myweb:touch:move:\";for(var i=0;i<e.touches.length;i++){if(i>0){str+=\"-\";}str+=e.touches[i].identifier+\",\"+e.touches[i].screenX+\",\"+e.touches[i].screenY;}document.location=str+\":\"+new Date().getTime();break;case \"touchend\":var str=\"myweb:touch:end:\";for(var i=0;i<e.touches.length;i++){if(i>0){str+=\"-\";}str+=e.touches[i].identifier+\",\"+e.touches[i].screenX+\",\"+e.touches[i].screenY;}document.location=str+\":\"+new Date().getTime();break;}}};document.addEventListener(\"touchstart\",anObject,false);document.addEventListener(\"touchmove\",anObject,false);document.addEventListener(\"touchend\",anObject,false);</script>"];
    //[super loadHTMLString:newHTMLString baseURL:baseURL];
    [super loadHTMLString:string baseURL:baseURL];
}



- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *requestString = [[request URL] absoluteString];
    //NSLog(@"::%@",requestString);
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"myweb"]) {
        
        if([components count] > 2 && [(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
            
        {
            //[components objectAtIndex:2]
            if([[components objectAtIndex:2] isEqualToString:@"start"] || [[components objectAtIndex:2] isEqualToString:@"move"]){
                if([components count] > 4){
                    NSArray *touchs = [[components objectAtIndex:3] componentsSeparatedByString:@"-"];
                    NSArray *touch;
                    for(NSInteger i=0;i<[touchs count];i++){
                        touch=[[touchs objectAtIndex:i] componentsSeparatedByString:@","];
                        if([touch count] ==3){
                            if(paths==nil){
                                paths=[[NSMutableDictionary alloc] init];
                            }
                            
                            NSMutableArray *temArr=nil;
                            
                            TouchPointObj *startPoint;

                            NSString *temTouch=[touch objectAtIndex:0];
                                if([paths objectForKey:temTouch]){
                                    tounchNum++;
                                }else{
                                    temArr=[[NSMutableArray alloc] init];
                                    [paths setObject:temArr forKey:temTouch];
                                    [temArr release];
                                    temArr=nil;
                                }
                                temArr=[paths objectForKey:temTouch];
                                startPoint=[[TouchPointObj alloc] init];
                                startPoint.touch=temTouch;
                                startPoint.origin=CGPointMake([[touch objectAtIndex:1] intValue],[[touch objectAtIndex:2] intValue]);
                                startPoint.time=[[components objectAtIndex:4] intValue];
                                
                                [temArr addObject:startPoint];
                            
                                [startPoint release];
                            
                        }
                    }
                }

            }else if([[components objectAtIndex:2] isEqualToString:@"end"]){
                //NSLog(@"end:::::%d",[components count]);
                if([components count] > 4){
                    if([[components objectAtIndex:3] isEqualToString:@""]){
                        [MainNC checkPaths:paths];
                        tounchNum=0;
                        Release2Nil(paths);
                    }
                }else{
                    [MainNC checkPaths:paths];
                    tounchNum=0;
                    Release2Nil(paths);
                }

            }else{
                
                
           
                //NSLog(@"::%@::%@",[components objectAtIndex:2],[components objectAtIndex:3]);
            } 
        }
        
        return NO;
        
    }
    
    return YES;
    
}

@end
