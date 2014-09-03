//
//  apiExtension.h
//  Device Cabinet
//
//  Created by Braun,Fee on 02.09.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"
#import "Person.h"

@interface ApiExtension : NSObject

- (void)storeDevice:(NSDictionary *)deviceJson completionHandler:(void (^)(NSError *error))completionHandler;
- (void)fetchAllDevices:(void (^)(NSArray *deviceObjects, NSError *error))completionHandler;
- (void)fetchDeviceWithDeviceId:(NSString *)deviceId completionHandler:(void (^)(Device *device, NSError *error))completionHandler;
- (void)fetchDevicesWithPersonId:(NSInteger *)personRecordId completionHandler:(void (^)(NSArray *deviceObjects, NSError *error))completionHandler;

- (void)storePerson:(NSDictionary *)personJson completionHandler:(void (^)(NSError *error))completionHandler;
- (void)fetchPersonWithUsername:(NSString *)username completionHandler:(void (^)(Person *person, NSError *error))completionHandler;

- (void)storeReferenceToBookedDeviceWithDeviceId:(int *)recordDeviceId personId:(int *)recordPersonId completionHandler:(void (^)(NSError *error))completionHandler;
- (void)deleteReferenceFromBookedDeviceWithDeviceId:(int *)deviceId personId:(int *)personId completionHandler:(void (^)(NSError *error))completionHandler;

@end
