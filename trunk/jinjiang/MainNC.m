//
//  MainNC.m
//  jinjiang
//
//  Created by Jeff.Yan on 11-10-27.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "MainNC.h"
#import "IntroVC.h"
#import "HelpVC.h"
#import "HomeVC.h"
#import "SearchVC.h"
#import "PromotionVC.h"
#import "AboutVC.h"

#import "ModalWebVC.h"

#import "GlobalFunction.h"
#import "NavigationView.h"
#import "TouchPointObj.h"

#import "jinjiangViewController.h"
#import "JJUIViewController.h"
#import "RootWindowUI.h"

#import "LoadingView.h"
#import "OmnitureManager.h"

@implementation MainNC


///////////

-(void)showPopLoader{
    [jinjiangViewController showLeaderView];
    
}
+(void)checkDelayMode:(NSInteger)mode{
    if(mode==2){
        [NavigationView select:5 mode:0];
        
    }
}
+(void)checkPaths:(NSMutableDictionary *)nd{
    ////NSLog(@"checkPaths::checkPaths");
    MainNC *mc=[MainNC sharedInstance];
    [mc checkPaths:nd];
    
}

-(BOOL)checkClick:(NSMutableDictionary *)nd{
    //NSLog(@"checkClick:::checkClick");
    if([nd count]==1){
        NSArray *na=[[nd allValues] objectAtIndex:0];
        if([na count]<4){
            for(NSInteger i=0;i<[na count];i++){
                if(i>0){
                    TouchPointObj *p0=[na objectAtIndex:i-1];
                    TouchPointObj *p1=[na objectAtIndex:i];
                    if([TouchPointObj calculateDis:p0.origin p0:p1.origin]>30 || fabs(p1.time-p0.time)>60){
                        return NO; 
                    }
                }
            }
            [cutVC setTouchMode:0 point:[[na objectAtIndex:0] origin]];
            return YES;
        }
    }
    
    return NO;
}
-(BOOL)checkJ:(NSMutableDictionary *)nd{
    if([nd count]==1){
        NSArray *na=[[nd allValues] objectAtIndex:0];
        ////NSLog(@"count:::%d",[na count]);
        if([na count]>4){
            
            TouchPointObj *p0=[na objectAtIndex:[na count]-1];
            TouchPointObj *p1;
            TouchPointObj *mp=[na objectAtIndex:0];
            if(p0.time-mp.time>1000){
                return NO;
            }
            
            CGFloat oldR=360;
            CGFloat tr=0;
            
            CGFloat temDis=0;
            
            NSInteger lt=0;
            NSInteger rt=0;
            NSInteger lb=0;
            NSInteger rb=0;
            
            CGFloat left=mp.origin.x;
            CGFloat right=mp.origin.x;
            CGFloat top=mp.origin.y;
            CGFloat bottom=mp.origin.y;
            
            
            
            CGFloat aDis=0;
            
            CGFloat tDis=0;
            
            CGFloat temR=0;
            
            CGFloat allR=0;
            
            CGFloat leftTop=2000;
            
            CGFloat isLeft=NO;
            
            NSInteger i;
            
            for(i=0;i<[na count];i++){
                p1=[na objectAtIndex:i];
                if(i>0){
                    p0=[na objectAtIndex:i-1];
                    
                    tDis=[TouchPointObj calculateDis:p1.origin p0:p0.origin];
                    //tr=[TouchPointObj calculateRotate:p1.origin p0:p0.origin];
                    temDis+=tDis;
                    aDis+=tDis;
                    
                    //temR+=tr;
                    
                    
                    if(temDis>60){
                        tr=[TouchPointObj calculateRotate:p1.origin p0:mp.origin];
                        // //NSLog(@"::%d:::%f::%f::%f::%f",i,p0.origin.x,p0.origin.y,tr,tr-oldR);
                        allR=fmax(180-tr,allR);
                        if(tr<90){
                            isLeft=YES;
                        }
                        if(isLeft){
                            if(tr<110){
                                if(tr-oldR>10){
                                    return NO; 
                                }
                            }else if(tr>330){
                                if(oldR>330){
                                    if(tr-oldR>10){
                                        return NO; 
                                    }
                                }else{
                                    if(tr<340){
                                        return NO; 
                                    } 
                                }
                            }else{
                                return NO; 
                                
                            }
                        }else{
                            if(tr>200 || tr<70 || tr-oldR>10){
                                // //NSLog(@"jjjj:::222");
                                return NO; 
                            }  
                        }
                        
                        mp=p1;
                        temDis=0;
                        temR=0;
                        oldR=tr;
                    }
                    
                    
                    
                }
                if(isLeft){
                    leftTop=fmin(leftTop, p1.origin.y);
                }
                left=fmin(left, p1.origin.x);
                right=fmax(right, p1.origin.x);
                
                top=fmin(top, p1.origin.y);
                bottom=fmax(bottom, p1.origin.y);
                
                
                left=fmin(left, p1.origin.x);
                
                p0=[na objectAtIndex:lt];
                if(p0.origin.x>=p1.origin.x || p0.origin.y<=p1.origin.y){
                    lt=i;
                }
                
                p0=[na objectAtIndex:rt];
                if(p0.origin.x<=p1.origin.x || p0.origin.y>=p1.origin.y){
                    rt=i;
                }
                
                p0=[na objectAtIndex:lb];
                if(p0.origin.x>=p1.origin.x || p0.origin.y<=p1.origin.y){
                    lb=i;
                }
                
                p0=[na objectAtIndex:rb];
                if(p0.origin.x<=p1.origin.x || p0.origin.y<=p1.origin.y){
                    rb=i;
                }
                
            }
            
            ////NSLog(@"jjjj:::rr:::%f:::%f:::%f:::%f",allR,leftTop,top,bottom);
            if(allR<90 || allR>200 || leftTop<top+(bottom-top)/2){
                //NSLog(@"jjjj:::rr2");
                return NO; 
            }
            
            
            CGPoint ltP=CGPointMake(left, top);
            CGPoint rtP=CGPointMake(right, top);
            CGPoint lbP=CGPointMake(left, bottom);
            CGPoint rbP=CGPointMake(right, bottom);
            
            CGFloat ltDis=2000;
            CGFloat rtDis=2000;
            CGFloat lbDis=2000;
            CGFloat rbDis=2000;
            
            for(i=0;i<[na count];i++){
                p1=[na objectAtIndex:i];
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:ltP];
                if(tDis<ltDis){
                    ltDis=tDis;
                }
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:rtP];
                if(tDis<rtDis){
                    rtDis=tDis;
                    rt=i;
                }
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:lbP];
                if(tDis<lbDis){
                    lbDis=tDis;
                    lb=i;
                }
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:rbP];
                if(tDis<rbDis){
                    rbDis=tDis;
                    rb=i;
                }
            }
            //NSLog(@"jjjj:::22:::%f:::%d:%d:%d:%d",aDis,lt,lb,rb,rt);
            if(aDis>300 && lt>=lb && lb>rb && rb>rt){
                //NSLog(@"jjjj:okkkkkkk");
                return YES;
            }
        }
        
    }
    //NSLog(@"jjjj:::::nnnnn");
    return NO;
}
-(BOOL)checkL:(NSMutableDictionary *)nd{
    if([nd count]==1){
        NSArray *na=[[nd allValues] objectAtIndex:0];
        //NSLog(@"checkL:::%d",[na count]);
        if([na count]>4){
            
            TouchPointObj *p0=[na objectAtIndex:[na count]-1];
            TouchPointObj *p1;
            TouchPointObj *mp=[na objectAtIndex:0];
            if(p0.time-mp.time>1000){
                return NO;
            }
            
            CGFloat oldR=120;
            CGFloat tr=0;
            
            CGFloat temDis=0;
            
            NSInteger lt=0;
            NSInteger rt=0;
            NSInteger lb=0;
            NSInteger rb=0;
            
            CGFloat left=mp.origin.x;
            CGFloat right=mp.origin.x;
            CGFloat top=mp.origin.y;
            CGFloat bottom=mp.origin.y;
            
            
            
            CGFloat aDis=0;
            
            CGFloat tDis=0;
            
            CGFloat temR=0;
            
            CGFloat allR=0;
            
            CGFloat leftTop=2000;
            
            CGFloat isLeft=NO;
            
            NSInteger i;
            
            for(i=0;i<[na count];i++){
                p1=[na objectAtIndex:i];
                if(i>0){
                    p0=[na objectAtIndex:i-1];
                    
                    tDis=[TouchPointObj calculateDis:p1.origin p0:p0.origin];
                    //tr=[TouchPointObj calculateRotate:p1.origin p0:p0.origin];
                    temDis+=tDis;
                    aDis+=tDis;
                    
                    //temR+=tr;
                    
                    
                    if(temDis>60){
                        tr=[TouchPointObj calculateRotate:p1.origin p0:mp.origin];
                        ////NSLog(@"checkL::%d:::%f::%f::%f::%f",i,p0.origin.x,p0.origin.y,tr,tr-oldR);
                        allR=fmax(tr-180,allR);
                        if(tr>220){
                            isLeft=YES;
                        }
                        if(isLeft){
                            if(tr<200 || tr-oldR<-10){
                                //NSLog(@"checkL:::222");
                                return NO; 
                            }
                            
                        }else{
                            if(tr<150 || tr>220 || tr-oldR<-10){
                                //NSLog(@"checkL:::111");
                                return NO; 
                            }
                        }
                        
                        
                        mp=p1;
                        temDis=0;
                        temR=0;
                        oldR=tr;
                    }
                    
                    
                    
                }
                if(isLeft){
                    leftTop=fmin(leftTop, p1.origin.y);
                }
                left=fmin(left, p1.origin.x);
                right=fmax(right, p1.origin.x);
                
                top=fmin(top, p1.origin.y);
                bottom=fmax(bottom, p1.origin.y);
                
                
                left=fmin(left, p1.origin.x);
                
                p0=[na objectAtIndex:lt];
                if(p0.origin.x>=p1.origin.x || p0.origin.y<=p1.origin.y){
                    lt=i;
                }
                
                p0=[na objectAtIndex:rt];
                if(p0.origin.x<=p1.origin.x || p0.origin.y>=p1.origin.y){
                    rt=i;
                }
                
                p0=[na objectAtIndex:lb];
                if(p0.origin.x>=p1.origin.x || p0.origin.y<=p1.origin.y){
                    lb=i;
                }
                
                p0=[na objectAtIndex:rb];
                if(p0.origin.x<=p1.origin.x || p0.origin.y<=p1.origin.y){
                    rb=i;
                }
                
            }
            
            ////NSLog(@"jjjj:::rr:::%f:::%f:::%f:::%f",allR,leftTop,top,bottom);
            if(allR<60 || allR>120 || leftTop<bottom-(bottom-top)/4){
                //NSLog(@"jjjj:::rr2");
                return NO; 
            }
            
            
            CGPoint ltP=CGPointMake(left, top);
            CGPoint rtP=CGPointMake(right, top);
            CGPoint lbP=CGPointMake(left, bottom);
            CGPoint rbP=CGPointMake(right, bottom);
            
            CGFloat ltDis=2000;
            CGFloat rtDis=2000;
            CGFloat lbDis=2000;
            CGFloat rbDis=2000;
            
            for(i=0;i<[na count];i++){
                p1=[na objectAtIndex:i];
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:ltP];
                if(tDis<ltDis){
                    ltDis=tDis;
                    lt=i;
                }
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:rtP];
                if(tDis<rtDis){
                    rtDis=tDis;
                    rt=i;
                }
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:lbP];
                if(tDis<lbDis){
                    lbDis=tDis;
                    lb=i;
                }
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:rbP];
                if(tDis<rbDis){
                    rbDis=tDis;
                    rb=i;
                }
            }
            //  //NSLog(@"checkl:::22:::%f:::%d:%d:%d:%d",aDis,lt,lb,rb,rt);
            if(aDis>400 && lt<lb && lb<rb){
                //NSLog(@"checkl:okkkkkkk");
                return YES;
            }
        }
        
    }
    return NO;
}

-(BOOL)check2Home:(NSMutableDictionary *)nd{
    NSArray *ana=[nd allValues];
    if([ana count]==3){
        CGFloat fdis=0;
        for(NSInteger n=0;n<[ana count];n++){
            CGFloat dis=0;
            NSArray *na=[ana objectAtIndex:n];
            for(NSInteger i=0;i<[na count];i++){
                if(i>0){
                    TouchPointObj *p0=[na objectAtIndex:i-1];
                    TouchPointObj *p1=[na objectAtIndex:i];
                    dis+=p1.origin.x-p0.origin.x;
                    if(fabs(p1.origin.y-p0.origin.y)>60){
                        return NO; 
                    }
                }
            }
            //NSLog(@":::::::%f",dis);
            if(fabs(dis)<100){
                return NO;  
            }
            fdis=fmax(fdis,fabs(dis));
        }
        if(fabs(fdis)>200){
            return YES;  
        }
        
        
    }
    return NO;
}
-(BOOL)checkNext:(NSMutableDictionary *)nd{
    if([nd count]==1){
        NSArray *na=[[nd allValues] objectAtIndex:0];
        //NSLog(@"checkNext:::%d",[na count]);
        if([na count]>4){
            
            TouchPointObj *p0=[na objectAtIndex:[na count]-1];
            TouchPointObj *p1;
            TouchPointObj *mp=[na objectAtIndex:0];
            if(p0.time-mp.time>1000){
                return NO;
            }
            
            CGFloat oldR=225;
            CGFloat tr=0;
            
            CGFloat temDis=0;
            
            NSInteger lt=0;
            NSInteger rt=0;
            NSInteger lb=0;
            NSInteger rb=0;
            
            CGFloat left=mp.origin.x;
            CGFloat right=mp.origin.x;
            CGFloat top=mp.origin.y;
            CGFloat bottom=mp.origin.y;
            
            
            
            CGFloat aDis=0;
            
            CGFloat tDis=0;
            
            CGFloat temR=0;
            
            CGFloat allR=0;
            
            CGFloat leftTop=2000;
            
            CGFloat isLeft=NO;
            
            NSInteger i;
            CGFloat pp=0;
            for(i=0;i<[na count];i++){
                p1=[na objectAtIndex:i];
                if(i>0){
                    p0=[na objectAtIndex:i-1];
                    
                    tDis=[TouchPointObj calculateDis:p1.origin p0:p0.origin];
                    //tr=[TouchPointObj calculateRotate:p1.origin p0:p0.origin];
                    temDis+=tDis;
                    aDis+=tDis;
                    
                    //temR+=tr;
                    
                    
                    if(temDis>60){
                        tr=[TouchPointObj calculateRotate:p1.origin p0:mp.origin];
                        //  //NSLog(@"checkNext::%d:::%f::%f::%f::%f",i,p0.origin.x,p0.origin.y,tr,tr-oldR);
                        allR=fmax(245-tr,allR);
                        if(!isLeft && tr<180){
                            pp=aDis;
                            isLeft=YES;
                        }
                        if(isLeft){
                            if(tr<120 || tr>180){
                                
                                return NO; 
                                
                            }
                        }else{
                            if(tr<180 || tr>240){
                                
                                return NO; 
                                
                            }
                        }
                        
                        mp=p1;
                        temDis=0;
                        temR=0;
                        oldR=tr;
                    }
                    
                    
                    
                }
                if(isLeft){
                    leftTop=fmin(leftTop, p1.origin.y);
                }
                left=fmin(left, p1.origin.x);
                right=fmax(right, p1.origin.x);
                
                top=fmin(top, p1.origin.y);
                bottom=fmax(bottom, p1.origin.y);
                
                
                left=fmin(left, p1.origin.x);
                
                p0=[na objectAtIndex:lt];
                if(p0.origin.x>=p1.origin.x || p0.origin.y<=p1.origin.y){
                    lt=i;
                }
                
                p0=[na objectAtIndex:rt];
                if(p0.origin.x<=p1.origin.x || p0.origin.y>=p1.origin.y){
                    rt=i;
                }
                
                p0=[na objectAtIndex:lb];
                if(p0.origin.x>=p1.origin.x || p0.origin.y<=p1.origin.y){
                    lb=i;
                }
                
                p0=[na objectAtIndex:rb];
                if(p0.origin.x<=p1.origin.x || p0.origin.y<=p1.origin.y){
                    rb=i;
                }
                
            }
            
            //   //NSLog(@"checkNext:::rr:::%f:::%f:::%f:::%f",allR,leftTop,top,bottom);
            
            if(pp<aDis/3 || pp>aDis/3*2 || !isLeft || allR<30 || allR>120 ){
                // //NSLog(@"checkNext:::rr2");
                return NO; 
            }
            
            
            CGPoint ltP=CGPointMake(left, top);
            CGPoint rtP=CGPointMake(right, top);
            CGPoint lbP=CGPointMake(left, bottom);
            CGPoint rbP=CGPointMake(right, bottom);
            
            CGFloat ltDis=2000;
            CGFloat rtDis=2000;
            CGFloat lbDis=2000;
            CGFloat rbDis=2000;
            
            for(i=0;i<[na count];i++){
                p1=[na objectAtIndex:i];
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:ltP];
                if(tDis<ltDis){
                    ltDis=tDis;
                    lt=i;
                }
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:rtP];
                if(tDis<rtDis){
                    rtDis=tDis;
                    rt=i;
                }
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:lbP];
                if(tDis<lbDis){
                    lbDis=tDis;
                    lb=i;
                }
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:rbP];
                if(tDis<rbDis){
                    rbDis=tDis;
                    rb=i;
                }
            }
            
            //  p0=[na objectAtIndex:lt];
            // p1=[na objectAtIndex:lb];
            tDis=fabs(bottom-top)/fabs(right-left);
            
            ////NSLog(@"checkNext:tDis::22:::%f:::%d:%d:%d:%d:%f",aDis,lt,lb,rb,rt,tDis);
            
            if(tDis<0.6 || tDis>4){
                return NO;
            }
            if(aDis>400 && lb>lt){
                ////NSLog(@"checkNext:okkkkkkk");
                return YES;
            }
            
            
        }
        
    }
    return NO;
}


-(BOOL)checkBack:(NSMutableDictionary *)nd{
    if([nd count]==1){
        NSArray *na=[[nd allValues] objectAtIndex:0];
        //NSLog(@"checkBack:::%d",[na count]);
        if([na count]>4){
            
            TouchPointObj *p0=[na objectAtIndex:[na count]-1];
            TouchPointObj *p1;
            TouchPointObj *mp=[na objectAtIndex:0];
            if(p0.time-mp.time>1000){
                return NO;
            }
            CGFloat oldR=225;
            CGFloat tr=0;
            
            CGFloat temDis=0;
            
            NSInteger lt=0;
            NSInteger rt=0;
            NSInteger lb=0;
            NSInteger rb=0;
            
            CGFloat left=mp.origin.x;
            CGFloat right=mp.origin.x;
            CGFloat top=mp.origin.y;
            CGFloat bottom=mp.origin.y;
            
            
            
            CGFloat aDis=0;
            
            CGFloat tDis=0;
            
            CGFloat temR=0;
            
            CGFloat allR=0;
            
            CGFloat leftTop=2000;
            
            CGFloat isLeft=NO;
            
            NSInteger i;
            
            CGFloat pp=0;
            
            for(i=0;i<[na count];i++){
                p1=[na objectAtIndex:i];
                if(i>0){
                    p0=[na objectAtIndex:i-1];
                    
                    tDis=[TouchPointObj calculateDis:p1.origin p0:p0.origin];
                    //tr=[TouchPointObj calculateRotate:p1.origin p0:p0.origin];
                    temDis+=tDis;
                    aDis+=tDis;
                    
                    //temR+=tr;
                    
                    
                    if(temDis>60){
                        tr=[TouchPointObj calculateRotate:p1.origin p0:mp.origin];
                        // //NSLog(@"checkBack::%d:::%f::%f::%f::%f",i,p0.origin.x,p0.origin.y,tr,tr-oldR);
                        allR=fmax(tr-90,allR);
                        if(!isLeft && tr>180){
                            pp=aDis;
                            isLeft=YES;
                        }
                        if(isLeft){
                            if(tr>250){
                                return NO; 
                                
                            }
                        }else{
                            if(tr<110){
                                
                                return NO; 
                                
                            }
                        }
                        
                        mp=p1;
                        temDis=0;
                        temR=0;
                        oldR=tr;
                    }
                    
                    
                    
                }
                if(isLeft){
                    leftTop=fmin(leftTop, p1.origin.y);
                }
                left=fmin(left, p1.origin.x);
                right=fmax(right, p1.origin.x);
                
                top=fmin(top, p1.origin.y);
                bottom=fmax(bottom, p1.origin.y);
                
                
                left=fmin(left, p1.origin.x);
                
                p0=[na objectAtIndex:lt];
                if(p0.origin.x>=p1.origin.x || p0.origin.y<=p1.origin.y){
                    lt=i;
                }
                
                p0=[na objectAtIndex:rt];
                if(p0.origin.x<=p1.origin.x || p0.origin.y>=p1.origin.y){
                    rt=i;
                }
                
                p0=[na objectAtIndex:lb];
                if(p0.origin.x>=p1.origin.x || p0.origin.y<=p1.origin.y){
                    lb=i;
                }
                
                p0=[na objectAtIndex:rb];
                if(p0.origin.x<=p1.origin.x || p0.origin.y<=p1.origin.y){
                    rb=i;
                }
                
            }
            
            // //NSLog(@"checkBack:::rr:::%f:::%f:::%f:::%f",allR,leftTop,top,bottom);
            
            if(pp<aDis/3 || pp>aDis/3*2 || !isLeft || allR<90 || allR>160 ){
                // //NSLog(@"checkBack:::rr2");
                return NO; 
            }
            
            
            CGPoint ltP=CGPointMake(left, top);
            CGPoint rtP=CGPointMake(right, top);
            CGPoint lbP=CGPointMake(left, bottom);
            CGPoint rbP=CGPointMake(right, bottom);
            
            CGFloat ltDis=2000;
            CGFloat rtDis=2000;
            CGFloat lbDis=2000;
            CGFloat rbDis=2000;
            
            for(i=0;i<[na count];i++){
                p1=[na objectAtIndex:i];
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:ltP];
                if(tDis<ltDis){
                    ltDis=tDis;
                    lt=i;
                }
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:rtP];
                if(tDis<rtDis){
                    rtDis=tDis;
                    rt=i;
                }
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:lbP];
                if(tDis<lbDis){
                    lbDis=tDis;
                    lb=i;
                }
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:rbP];
                if(tDis<rbDis){
                    rbDis=tDis;
                    rb=i;
                }
            }
            
            //  p0=[na objectAtIndex:lt];
            // p1=[na objectAtIndex:lb];
            tDis=fabs(bottom-top)/fabs(right-left);
            
            // //NSLog(@"checkNext:tDis::22:::%f:::%d:%d:%d:%d:%f",aDis,lt,lb,rb,rt,tDis);
            //  //NSLog(@"tDis:::::%f:%f",tDis,aDis);
            if(tDis<0.6 || tDis>4){
                return NO;
            }
            if(aDis>400 && rb>rt){
                //NSLog(@"checkBack:okkkkkkk");
                return YES;
            }
            
            
        }
        
    }
    return NO;
}

//showPopLoader
-(BOOL)checkPop:(NSMutableDictionary *)nd{
    if([nd count]==1){
        NSArray *na=[[nd allValues] objectAtIndex:0];
        //NSLog(@"checkPop:::%d",[na count]);
        if([na count]>4){
            NSMutableArray *cachePoint=[[[NSMutableArray alloc] init] autorelease];
            TouchPointObj *p0=[na objectAtIndex:[na count]-1];
            TouchPointObj *p1;
            TouchPointObj *mp=[na objectAtIndex:0];
            if(p0.time-mp.time>1500 || [TouchPointObj calculateDis:mp.origin p0:p0.origin]>200){
                return NO;
            }
            CGFloat oldR=-1000;
            CGFloat tr=0;
            
            CGFloat temDis=0;
            
            NSInteger lt=0;
            NSInteger rt=0;
            NSInteger lb=0;
            NSInteger rb=0;
            
            CGFloat left=mp.origin.x;
            CGFloat right=mp.origin.x;
            CGFloat top=mp.origin.y;
            CGFloat bottom=mp.origin.y;
            
            
            
            CGFloat aDis=0;
            
            CGFloat tDis=0;
            
            CGFloat temR=0;
            
            CGFloat allR=0;
            
            
            
            NSInteger i;
            
            
            
            for(i=0;i<[na count];i++){
                p1=[na objectAtIndex:i];
                if(i>0){
                    p0=[na objectAtIndex:i-1];
                    
                    tDis=[TouchPointObj calculateDis:p1.origin p0:p0.origin];
                    temDis+=tDis;
                    aDis+=tDis;
                    
                    //temR+=tr;
                    
                    
                    if(temDis>60){
                        tr=[TouchPointObj calculateRotate:p1.origin p0:mp.origin];
                        
                        if(oldR!=-1000){
                            temR=tr-oldR;
                            if(temR>300){
                                temR=temR-360;
                            }else if(temR<-300){
                                temR=temR+360;
                            }
                            allR+=temR;
                            
                            NSMutableDictionary *tdic=[[NSMutableDictionary alloc] init];
                            [tdic setObject:[NSNumber numberWithFloat:temR] forKey:@"r"];
                            [tdic setObject:mp forKey:@"p"];
                            [cachePoint addObject:tdic];
                            [tdic release];
                            
                            //  //NSLog(@":::%f::%f",fabs(temR),allR);
                            if(fabs(temR)>70 && fabs(temR)<290){
                                //NSLog(@"checkPop:::rr1");
                                return NO; 
                                
                            }
                        }
                        // allR=fmax(tr-90,allR);
                        
                        
                        
                        mp=p1;
                        temDis=0;
                        
                        oldR=tr;
                    }
                    
                    
                    
                }
                
                left=fmin(left, p1.origin.x);
                right=fmax(right, p1.origin.x);
                
                top=fmin(top, p1.origin.y);
                bottom=fmax(bottom, p1.origin.y);
                
                
                left=fmin(left, p1.origin.x);
                
                p0=[na objectAtIndex:lt];
                if(p0.origin.x>=p1.origin.x || p0.origin.y<=p1.origin.y){
                    lt=i;
                }
                
                p0=[na objectAtIndex:rt];
                if(p0.origin.x<=p1.origin.x || p0.origin.y>=p1.origin.y){
                    rt=i;
                }
                
                p0=[na objectAtIndex:lb];
                if(p0.origin.x>=p1.origin.x || p0.origin.y<=p1.origin.y){
                    lb=i;
                }
                
                p0=[na objectAtIndex:rb];
                if(p0.origin.x<=p1.origin.x || p0.origin.y<=p1.origin.y){
                    rb=i;
                }
                
            }
            
            temR=allR/[cachePoint count];
            //NSLog(@"checkPop:::%f::%f::%f::%f::%f",allR,aDis,(left-right)/(top-bottom),(left-right),(top-bottom));
            if(fabs(fabs(allR)-360)>60 || aDis<300 || aDis>2200 || fabs(fabs((left-right)/(top-bottom))-1)>0.5){
                //NSLog(@"checkPop:::rr3");
                return NO; 
            }
            
            
            CGPoint ltP=CGPointMake(left, top);
            CGPoint rtP=CGPointMake(right, top);
            CGPoint lbP=CGPointMake(left, bottom);
            CGPoint rbP=CGPointMake(right, bottom);
            
            CGFloat ltDis=2000;
            CGFloat rtDis=2000;
            CGFloat lbDis=2000;
            CGFloat rbDis=2000;
            
            for(i=0;i<[cachePoint count];i++){
                allR=[(NSNumber *)[[cachePoint objectAtIndex:i] objectForKey:@"r"] floatValue]-temR;
                
                ////NSLog(@":::::%f:::::%f::::%f",[(NSNumber *)[[cachePoint objectAtIndex:i] objectForKey:@"r"] floatValue],allR,temR);
                if(fabs(allR)>30){
                    return NO;
                }
                p1=[[cachePoint objectAtIndex:i] objectForKey:@"p"];
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:ltP];
                if(tDis<ltDis){
                    ltDis=tDis;
                    lt=i;
                }
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:rtP];
                if(tDis<rtDis){
                    rtDis=tDis;
                    rt=i;
                }
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:lbP];
                if(tDis<lbDis){
                    lbDis=tDis;
                    lb=i;
                }
                
                tDis=[TouchPointObj calculateDis:p1.origin p0:rbP];
                if(tDis<rbDis){
                    rbDis=tDis;
                    rb=i;
                }
            }
            // ltDis=lt-rt;
            //rtDis=rb-rt;
            //rtDis
            
            
            //NSLog(@"checkPop:okkkkkkk");
            return YES;
            
            
            
        }
        
    }
    return NO;
}

-(void)checkPaths:(NSMutableDictionary *)nd{
    //NSArray *touches=[nd allValues];
    //NSLog(@"checkPaths");
    switch (pageIndex) {
        case 0:
            if([self checkClick:nd]){
                
            }else if([self checkJ:nd]){
                [NavigationView select:1 mode:0];
            }
            break;
        case 1:
            if([self checkClick:nd]){
            }else if([self checkL:nd]){
                [NavigationView select:0 mode:0];
                // }else if([self check2Seach:nd]){
            }else if([self checkPop:nd]){
                [self showPopLoader];
            }
            break;
        case 2:
            if([self checkClick:nd]){
            }else if([self checkL:nd]){
                [NavigationView select:0 mode:0];
                // }else if([self check2Seach:nd]){
            }else if([self checkPop:nd]){
                [self showPopLoader];
            }
            break;
        case 3:
            if([self checkClick:nd]){
                [NavigationView off2Out];
            }else if([self checkL:nd]){
                [NavigationView select:0 mode:0];
            }else if([self check2Home:nd]){
                [NavigationView select:2 mode:0];
            }else if([self checkPop:nd]){
                [self showPopLoader];
                //}else if([self checkBack:nd]){
                // [NavigationView select:7 mode:2];
            }
            
            break;
        case 4:
            if([self checkClick:nd]){
                [NavigationView off2Out];
            }else if([self checkL:nd]){
                [NavigationView select:0 mode:0];
            }else if([self check2Home:nd]){
                [NavigationView select:2 mode:0];
            }else if([self checkPop:nd]){
                [self showPopLoader];
                //}else if([self checkNext:nd]){
                // [NavigationView select:5 mode:0];
                // }else if([self checkBack:nd]){
                
                //[NavigationView select:3 mode:2];
            }
            
            break;
        case 5:
            if([self checkClick:nd]){
                [NavigationView off2Out];
            }else if([self checkL:nd]){
                [NavigationView select:0 mode:0];
            }else if([self check2Home:nd]){
                [NavigationView select:2 mode:0];
            }else if([self checkPop:nd]){
                [self showPopLoader];
                /*
                 }else if([self checkNext:nd]){
                 [NavigationView select:6 mode:0];
                 }else if([self checkBack:nd]){
                 [NavigationView select:4 mode:2];*/
            }
            
            break;
        case 6:
            if([self checkClick:nd]){
                [NavigationView off2Out];
            }else if([self checkL:nd]){
                [NavigationView select:0 mode:0];
            }else if([self check2Home:nd]){
                [NavigationView select:2 mode:0];
            }else if([self checkPop:nd]){
                [self showPopLoader];
                /*
                 }else if([self checkNext:nd]){
                 [NavigationView select:7 mode:0];
                 }else if([self checkBack:nd]){
                 [NavigationView select:5 mode:2];*/
            }
            
            break;
        case 7:
            if([self checkClick:nd]){
                [NavigationView off2Out];
            }else if([self checkL:nd]){
                [NavigationView select:0 mode:0];
            }else if([self check2Home:nd]){
                [NavigationView select:2 mode:0];
            }else if([self checkPop:nd]){
                [self showPopLoader];/*
                                      }else if([self checkNext:nd]){
                                      [NavigationView select:3 mode:0];
                                      }else if([self checkBack:nd]){
                                      [NavigationView select:6 mode:2];*/
            }
            
            break;
            
        default:
            break;
    }
    
}

///


- (void)dealloc
{
    Release2Nil(cutVC);
    Release2Nil(_clubVC);
    [super dealloc];
}

static MainNC *_instance = nil;
+ (id)sharedInstance
{
    
    @synchronized(self)
    {
        if (_instance == nil) {
            _instance =[[MainNC alloc] init]; 
            _instance.navigationBar.hidden=true;
            _instance.view.frame=FULLRECT;
            [NavigationView select:0 mode:-1];
            //_instance.view.backgroundColor=[UIColor colorWithRed:0.478f green:0.478f blue:0.478f alpha:1.0f];
        }
        
    }
    return _instance;
}
+ (void)shareRelease
{
    [MenuItemVW releaseIndexArray];
    Release2Nil(_instance);
}

-(void)toShowPage:(NSInteger)index mode:(NSInteger)mode{
    //NSLog(@"toShowPage--00::::::");
    [jinjiangViewController dismissUV];
    /*
     if(index==7){
     ModalWebVC *duc=[[ModalWebVC alloc] init];
     [duc loadUrl:@"http://www.baidu.com"];
     pageIndex=index;
     [jinjiangViewController modalUV:duc];
     [duc release];
     return;
     } 
     */
    //NSLog(@"toShowPage--11::::::");
    if(mode==2 && cutVC==nil){
        mode=0;
    }
    if(cutVC!=nil){
        [cutVC outFun];
        Release2Nil(cutVC);
    }
    //NSLog(@"toShowPage--22::::::");
    JJUIViewController *uc=nil;
    
    switch (index) {
        case 0:
            uc=[[IntroVC alloc] init];
            [NavigationView showHide:YES];
            break;
        case 1:
            uc=[[HelpVC alloc] init];
            [NavigationView showHide:YES];
            break;
        case 2:
            uc=[[HomeVC alloc] init];
            [NavigationView showHide:YES];
            break;
        case 3:
            if (!_jj360VC) {
                _jj360VC = [[JJ360VC alloc] init];
            }
            uc = [_jj360VC retain];
            [NavigationView offOut:YES];
            [NavigationView showHide:NO autoHide:NO];
            break;
        case 4:
            if (!_clubVC) {
                _clubVC = [[ClubVC alloc] init];
            }
            uc = [_clubVC retain];
            [NavigationView offOut:YES];
            [NavigationView showHide:NO autoHide:NO];
            break;
        case 5:
            uc=[[SearchVC alloc] init];
            [NavigationView offOut:YES];
            [NavigationView showHide:NO autoHide:NO];
            break;
        case 6:
            uc=[[PromotionVC alloc] init];
            [NavigationView offOut:YES];
            [NavigationView showHide:NO autoHide:NO];
            break;
        case 7:
            uc=[[AboutVC alloc] init];
            [NavigationView offOut:YES];
            [NavigationView showHide:NO autoHide:NO];
            break;
            
        default:
            break;
    }
    //NSLog(@"toShowPage--22::::::");
    if(uc!=nil){
        
        pageIndex=index;
        
        
        if(uc!=nil){
            cutVC=[uc retain];
        }
        if(mode==-1){
            [self popToRootViewControllerAnimated:NO];
            [self pushViewController:uc animated:NO];
        }else if(mode==0){
            [self popToRootViewControllerAnimated:NO];
            [self pushViewController:uc animated:YES];
        }else if(mode==1){
            [self popToRootViewControllerAnimated:NO];
            [self pushViewController:uc animated:NO];
            uc.view.alpha=0;
            [GlobalFunction fadeInOut:uc.view to:1 time:0.6 hide:NO];
        }else if(mode==2){
            [self popToRootViewControllerAnimated:NO];
            [self pushViewController:uc animated:NO];
            [self pushViewController:cutVC animated:NO];
            [self popViewControllerAnimated:YES];
            
        }
        [RootWindowUI setTouchView:cutVC];
        
    }
    //NSLog(@"toShowPage--33::::::");
    [uc release];
    //NSLog(@"toShowPage--44::::::");
}
+(void)toShowPage:(NSInteger)index mode:(NSInteger)mode{
    // NSLog(@"toShowPage++::::::");
    MainNC *mc=[MainNC sharedInstance];
    [mc toShowPage:index mode:mode];
}


@end
