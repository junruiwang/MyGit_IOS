//
//  PromotionsParser.m
//  JinJiangTravelPlus
//
//  Created by 吕 硕 on 13-1-6.
//  Copyright (c) 2013年 JinJiang. All rights reserved.
//

#import "PromotionsParser.h"
#import "GDataXMLNode.h"
#import "Promotion.h"

@implementation PromotionsParser

- (BOOL)parseXmlString:(NSString *)xmlString
{
    if ([super parseXmlString:xmlString])
    {
        NSError* error; //NSLog(@"xmlString = %@", xmlString);
        GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
        GDataXMLElement* rootElement = [document rootElement];

        GDataXMLElement* promotionsDataElement = [rootElement elementsForName:@"promotions"][0];
        NSArray* promotionElementArray = [promotionsDataElement elementsForName:@"promotion"];

        NSMutableArray* promotionArray = [[NSMutableArray alloc] initWithCapacity:[promotionElementArray count]];

        for (GDataXMLElement* promotionElement in promotionElementArray)
        {
            Promotion* promotion = [[Promotion alloc] init];

            NSString* promotion_id = [[promotionElement attributeForName:@"id"]     stringValue];
            NSString* title  = [[promotionElement firstElementForName:@"title"]     stringValue];
            NSString* body_  = [[promotionElement firstElementForName:@"body"]      stringValue];
            NSString* link_  = [[promotionElement firstElementForName:@"link"]      stringValue];
            NSString* banner = [[promotionElement firstElementForName:@"banner"]    stringValue];
            NSString* prodID = [[promotionElement firstElementForName:@"productId"] stringValue];
            NSString* share  = [[promotionElement firstElementForName:@"shareDesc"]     stringValue];
            NSString* small  = [[promotionElement firstElementForName:@"smallBanner"]   stringValue];
            NSString* large  = [[promotionElement firstElementForName:@"largeBanner"]   stringValue];
            NSString* proACT = [[promotionElement firstElementForName:@"productAction"] stringValue];
            NSString* proCAT = [[promotionElement firstElementForName:@"productCategory"] stringValue];

            [promotion setPromotionId:[promotion_id integerValue]];
            [promotion setTitle:title];[promotion setBody:body_];
            [promotion setShareDesc:share];
            [promotion setProductId:[prodID integerValue]];
            [promotion setActionId:[proACT integerValue]];
            [promotion setBannerLink:banner];
            [promotion setSmallBannerLink:small];
            [promotion setLargeBannerLink:large];

            if ([[link_ componentsSeparatedByString:@":"] count] >= 2)
            {
                [promotion setWebLink:link_];

                if ([proCAT rangeOfString:PromotionPhoto].location!= NSNotFound)
                {   [promotion setCategory:PromotionCategoryPicture];   }
                else if ([proCAT rangeOfString:PromotionRegister].location!= NSNotFound)
                {   [promotion setCategory:PromotionCategoryRegister];  }
                else if ([proCAT rangeOfString:PromotionActivate].location!= NSNotFound)
                {   [promotion setCategory:PromotionCategoryActivate];  }
                else if ([proCAT rangeOfString:PromotionHotelSearch].location!= NSNotFound)
                {   [promotion setCategory:PromotionCategoryHotelSearch];   }
                else if ([proCAT rangeOfString:PromotionJINNSearch].location!= NSNotFound)
                {   [promotion setCategory:PromotionCategoryJINNSearch];    }
                else if ([proCAT rangeOfString:PromotionHotel].location!= NSNotFound)
                {   [promotion setCategory:PromotionCategoryHotel]; }
                else
                {   [promotion setCategory:PromotionCategoryWeblink];   }
            }
            else
            {
                [promotion setCategory:PromotionCategoryUnknown];
                [promotion setWebLink:link_];   kPrintfInfo;
            }

            [promotionArray addObject:promotion];
            //NSLog(@"[promotion webLink] = %@, proCAT= %@", [promotion webLink], proCAT);
        }

        NSDictionary* data = @{@"total":@(promotionArray.count), @"promotionArray":promotionArray};
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:DidParsedData:)])
        {   [self.delegate parser:self DidParsedData:data]; }
    }
    return YES;
}

@end
