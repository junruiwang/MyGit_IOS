//
//  LvPingRatingParser.m
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-10.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "LvPingRatingParser.h"
#import "HotelRoomListParser.h"
#import "GDataXMLNode.h"
#import "LvPingHotelRating.h"
#import "LvPingUserRating.h"

@implementation LvPingRatingParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString] ) {
        NSError* error;
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
        
        if ([rootElement elementsForName:@"hotel"].count > 0) {
            LvPingHotelRating *lvPingHotelRating = [[LvPingHotelRating alloc] init];
            GDataXMLElement *hotelElement = [rootElement firstElementForName:@"hotel"];
            lvPingHotelRating.hotelId = [[hotelElement attributeForName:@"id"] intValue];
            lvPingHotelRating.hotelRate = [[hotelElement firstElementForName:@"hotelRate"] stringValue];
            lvPingHotelRating.hotelRank = [[hotelElement firstElementForName:@"hotelRank"] stringValue];
            lvPingHotelRating.hotelUrl = [[hotelElement firstElementForName:@"hotelUrl"] stringValue];
            lvPingHotelRating.writeUrl = [[hotelElement firstElementForName:@"writeUrl"] stringValue];
                        
            GDataXMLElement *ratingsElement = [hotelElement firstElementForName:@"userRatings"];
            NSArray *userRatingArray = [ratingsElement elementsForName:@"userRating"];
            NSMutableArray *userRatings = [[NSMutableArray alloc] init];
            for (GDataXMLElement *ratingElement in userRatingArray) {
                LvPingUserRating *lvPingUserRating = [[LvPingUserRating alloc] init];
                lvPingUserRating.nickName = [[ratingElement firstElementForName:@"nickName"] stringValue];
                lvPingUserRating.title = [[ratingElement firstElementForName:@"title"] stringValue];
                lvPingUserRating.content = [[ratingElement firstElementForName:@"content"] stringValue];
                lvPingUserRating.wdate = [[ratingElement firstElementForName:@"wdate"] stringValue];
                [userRatings addObject:lvPingUserRating];
            }
            lvPingHotelRating.userRatings = userRatings;
            NSDictionary *data = @{@"lvPingHotelRating":lvPingHotelRating};
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
                [self.delegate parser:self DidParsedData:data];
        }
    }
    return YES;
}

@end
