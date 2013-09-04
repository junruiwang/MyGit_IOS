//
//  AreaListHandle.h
//  JinJiangTravelPlus
//
//  Created by 胡 桂祁 on 11/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "AreaListParser.h"


@protocol AreaListHandleDelegate

- (void) setAreaList : (NSMutableArray *) areaList;

@end

@interface AreaListHandle : NSObject <GDataXMLParserDelegate>

@property (nonatomic, weak) id<AreaListHandleDelegate> areaListHandleDelegate;
@property (nonatomic, strong) AreaListParser *areaListParser;

-(void)buildAreas;

@end
