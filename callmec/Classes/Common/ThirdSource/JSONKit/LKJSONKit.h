//
//  LKJSONKit.h
//
//  Created by Likid on 14-1-3.
//
//

#import <Foundation/Foundation.h>

////////////
#pragma mark Deserializing methods
////////////

@interface NSString (LKJSONKitDeserializing)
- (id)lk_objectFromJSONString;
@end

@interface NSData (LKJSONKitDeserializing)
// The NSData MUST be UTF8 encoded JSON.
- (id)lk_objectFromJSONData;
@end

////////////
#pragma mark Serializing methods
////////////

@interface NSString (LKJSONKitSerializing)
- (NSData *)lk_JSONData;
- (NSString *)lk_JSONString;
@end

@interface NSArray (LKJSONKitSerializing)
- (NSData *)lk_JSONData;
- (NSString *)lk_JSONString;
@end

@interface NSDictionary (LKJSONKitSerializing)
- (NSData *)lk_JSONData;
- (NSString *)lk_JSONString;
@end
