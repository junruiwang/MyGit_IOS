//
//  HotelRoomListParser.m
//  JinJiangTravelPlus
//
//  Created by Leon on 11/19/12.
//  Copyright (c) 2012 JinJiang. All rights reserved.
//

#import "HotelRoomListParser.h"
#import "GDataXMLNode.h"
#import "JJHotel.h"
#import "JJHotelRoom.h"
#import "JJPlan.h"
#import "RoomInfoContainer.h"

@implementation HotelRoomListParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString])
    {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];

        NSMutableArray *roomList = [[NSMutableArray alloc] init];
        if ([rootElement elementsForName:@"hotel"].count > 0)
        {
            GDataXMLElement *hotelElement = [rootElement firstElementForName:@"hotel"];
            const int hotelId = [[hotelElement attributeForName:@"id"] intValue];
            NSString *hotelCode = [[hotelElement firstElementForName:@"code"] stringValue];
            JJHotelOrigin hotelOrigin = [JJHotel originFromName:[[hotelElement firstElementForName:@"origin"] stringValue]];
            GDataXMLElement *roomsElement = [hotelElement firstElementForName:@"rooms"];
            NSArray *roomElementArray = [roomsElement elementsForName:@"room"];

            for (GDataXMLElement *roomElement in roomElementArray)
            {
                JJHotelRoom *hotelRoom = [[JJHotelRoom alloc] init];
                hotelRoom.roomId = [[roomElement attributeForName:@"id"] intValue];
                hotelRoom.name = [[roomElement firstElementForName:@"name"] stringValue];
                hotelRoom.imageurl = [[roomElement firstElementForName:@"imageUrl"] stringValue];
                hotelRoom.roomDesc = [[roomElement firstElementForName:@"desc"] stringValue];
                hotelRoom.service = [[roomElement firstElementForName:@"service"] stringValue];

                //酒店房型信息
                GDataXMLElement *roomInfoElement = [roomElement firstElementForName:@"infoContainer"];
                
                RoomInfoContainer *infoContainer = [[RoomInfoContainer alloc] init];
                switch (hotelOrigin) {
                    case JJHotelOriginJREZ:
                    {
                        infoContainer.roomArea = [[roomInfoElement firstElementForName:@"roomArea"] stringValue];
                        infoContainer.bedType = [[roomInfoElement firstElementForName:@"bedType"] stringValue];
                        infoContainer.floor = [[roomInfoElement firstElementForName:@"floor"] stringValue];
                        infoContainer.extraBed = [[roomInfoElement firstElementForName:@"extraBed"] stringValue];
                        infoContainer.wlan = [[roomInfoElement firstElementForName:@"wlan"] stringValue];
                        infoContainer.charge = [[roomInfoElement firstElementForName:@"charge"] stringValue];
                        infoContainer.nonSmokingRoom = [[roomInfoElement firstElementForName:@"nonSmokingRoom"] stringValue];
                        infoContainer.window = [[roomInfoElement firstElementForName:@"window"] stringValue];
                        infoContainer.otherBusiness = [[roomInfoElement firstElementForName:@"otherBusiness"] stringValue];
                        break;
                    }
                    default:
                        break;
                }
                hotelRoom.infoContainer = infoContainer;
                
                GDataXMLElement *plansElement = [roomElement firstElementForName:@"plans"];
                NSArray *planElementArray = [plansElement elementsForName:@"plan"];
                NSMutableArray *planList = [[NSMutableArray alloc] init];

                for (GDataXMLElement *planElement in planElementArray)
                {
                    JJPlan *plan = [[JJPlan alloc] init];
                    plan.planId = [[planElement attributeForName:@"id"] intValue];
                    plan.planName = [[planElement firstElementForName:@"name"] stringValue];
                    plan.rateCode = [[planElement firstElementForName:@"rateCode"] stringValue];
                    plan.breakfast = [JJPlan breakfastFromName:[[planElement firstElementForName:@"breakfast"] stringValue]];
                    plan.network = [JJPlan networkFromName:[[planElement firstElementForName:@"lan"] stringValue]];
                    plan.desc = [[planElement firstElementForName:@"desc"] stringValue];
                    plan.price = [[planElement firstElementForName:@"price"] intValue];
                    plan.guarantee = [[planElement firstElementForName:@"guarantee"] stringValue];
                    plan.roomAvai = [JJPlan roomavaiFromName:[[planElement firstElementForName:@"roomAvai"] stringValue]];
                    [planList addObject:plan];
                }

                hotelRoom.planList = planList;
                [roomList addObject:hotelRoom];
            }
            NSDictionary *data = @{@"hotelId":@(hotelId),@"hotelCode":hotelCode,@"hotelOrigin":@(hotelOrigin),@"roomList":roomList};
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
            {   [self.delegate parser:self DidParsedData:data]; }
        }
    }
    return YES;
}

@end
