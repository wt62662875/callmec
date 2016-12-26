//
//  LKJSONKit.m
//
//  Created by LIkid on 14-1-3.
//
//

#import "LKJSONKit.h"
//#import "LKLogger.h"

NSString *const DeserializeFailed = @"Deserialize Failed";
NSString *const SerializedFailed = @"Serialized Failed";

#define LKLogError NSLog

id LKJSONKitDeSerializeObjectWithData(NSData *data) {
    NSError *error;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!JSONObject) {
        LKLogError(@"JSONObject generateed error: %@", error);
    }

    return JSONObject;
}

NSData *LKHMJSONKitSerializeObject(id object) {
    if (![NSJSONSerialization isValidJSONObject:object])
        return nil;

    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    if (!data) {
        LKLogError(@"JSONData generateed error: %@", error);
    }

    return data;
}

#pragma mark - Deserialization

@implementation NSString (LKJSONKitDeserializing)

- (id)lk_objectFromJSONString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return LKJSONKitDeSerializeObjectWithData(data);
}

@end

@implementation NSData (LKJSONKitDeserializing)

- (id)lk_objectFromJSONData {
    return LKJSONKitDeSerializeObjectWithData(self);
}

@end

#pragma mark - Serialization

@implementation NSString (LKJSONKitSerializing)

- (NSData *)lk_JSONData {
    return LKHMJSONKitSerializeObject(self);
}

// 没用到，很奇怪，为啥是 string 了还要进行转换
- (NSString *)lk_JSONString {
    NSData *data = LKHMJSONKitSerializeObject(self);
    NSString *LKJSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return LKJSONString;
}

@end

@implementation NSArray (LKJSONKitSerializing)

- (NSData *)lk_JSONData {
    return LKHMJSONKitSerializeObject(self);
}

- (NSString *)lk_JSONString {
    NSData *data = LKHMJSONKitSerializeObject(self);
    NSString *LKJSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return LKJSONString;
}

@end

@implementation NSDictionary (LKJSONKitSerializing)

- (NSData *)lk_JSONData {
    return LKHMJSONKitSerializeObject(self);
}

- (NSString *)lk_JSONString {
    NSData *data = LKHMJSONKitSerializeObject(self);
    NSString *LKJSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return LKJSONString;
}

@end
