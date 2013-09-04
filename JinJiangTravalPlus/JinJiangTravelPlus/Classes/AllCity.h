#import <Foundation/Foundation.h>

@interface AllCity : NSObject<NSCoding>

- (id) initWithDictionary : (NSDictionary *) dict;

@property(nonatomic, retain) NSString *key;

@property(nonatomic, retain) NSString *name;

@property(nonatomic, retain) NSString *provinceName;

@end
