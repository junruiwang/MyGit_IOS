//
//  Brand.m
//  JinJiangTravalPlus
//
//  Created by jerry on 12-11-5.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import "Brand.h"

@implementation Brand

- (id)initWithCode:(NSString *)brandCode name:(NSString *) brandName image:(NSString *) brandImage;
{
    if (self = [super init]) {
        self.brandCode = brandCode;
        self.brandName = brandName;
        self.brandImage = brandImage;
        self.isSelected = NO;
    }

    return self;
}

+ (NSArray *)getBrandList
{
    Brand *brand_nil = [[Brand alloc] initWithCode:nil name:@"全部品牌" image:nil];
    Brand *brand_1 = [[Brand alloc] initWithCode:@"JJHOTEL" name:@"锦江酒店" image:@"jinjianghotel.png"];
    Brand *brand_2 = [[Brand alloc] initWithCode:@"SHANGYUE" name:@"商悦大酒店" image:@"shangyue.png"];
    Brand *brand_3 = [[Brand alloc] initWithCode:@"JJINN" name:@"锦江之星" image:@"jinjiangstart.png"];
    Brand *brand_4 = [[Brand alloc] initWithCode:@"BESTAY" name:@"百时快捷酒店" image:@"baishikuaijie.png"];
    Brand *brand_5 = [[Brand alloc] initWithCode:@"BYL" name:@"白玉兰酒店" image:@"baiyulan.png"];
    Brand *brand_6 = [[Brand alloc] initWithCode:@"JG" name:@"金广快捷" image:@"jinguangkuaijie.png"];
    return [NSArray arrayWithObjects:brand_nil, brand_1, brand_2, brand_3, brand_4, brand_5, brand_6, nil];
}

//+(NSArray *)getOldBrandListSDW
//{
//    Brand *brand_nil = [[Brand alloc] initWithCode:nil name:@"全部品牌" image:nil];
//    Brand *brand_1 = [[Brand alloc] initWithCode:@"JJHOTEL" name:@"锦江酒店" image:@"jinjianghotel-old.png"];
//    Brand *brand_2 = [[Brand alloc] initWithCode:@"SHANGYUE" name:@"商悦大酒店" image:@"shangyue-old.png"];
//    Brand *brand_3 = [[Brand alloc] initWithCode:@"JJINN" name:@"锦江之星" image:@"jinjiangstart-old.png"];
//    Brand *brand_4 = [[Brand alloc] initWithCode:@"BESTAY" name:@"百时快捷酒店" image:@"baishikuaijie-old.png"];
//    Brand *brand_5 = [[Brand alloc] initWithCode:@"BYL" name:@"白玉兰酒店" image:@"baiyulan-old.png"];
//    Brand *brand_6 = [[Brand alloc] initWithCode:@"JG" name:@"金广快捷" image:@"jinguangkuaijie-old.png"];
//    return [NSArray arrayWithObjects:brand_nil, brand_1, brand_2, brand_3, brand_4, brand_5, brand_6, nil];
//}

- (BOOL) isDefault
{
    return self.brandCode == nil;
}


@end
