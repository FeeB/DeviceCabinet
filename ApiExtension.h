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

- (void)storeDevice:(NSData *)deviceJson completionHandler:(void (^)(NSError *error))completionHandler;
- (void)fetchAllDevices:(void (^)(NSArray *deviceObjects, NSError *error))completionHandler;
- (void)fetchDeviceWithDeviceId:(int *)deviceId completionHandler:(void (^)(Device *device, NSError *error))completionHandler;
- (void)fetchDevicesWithPersonId:(int *)personId completionHandler:(void (^)(NSArray *deviceObjects, NSError *error))completionHandler;

- (void)storePerson:(NSData *)personJson completionHandler:(void (^)(NSError *error))completionHandler;
- (void)fetchPersonWithUsername:(NSString *)username completionHandler:(void (^)(Person *person, NSError *error))completionHandler;

- (void)storeReferenceToBookedDeviceWithDeviceId:(int *)recordDeviceId personId:(int *)recordPersonId completionHandler:(void (^)(NSError *error))completionHandler;
- (void)deleteReferenceFromBookedDeviceWithDeviceId:(int *)deviceId personId:(int *)personId completionHandler:(void (^)(NSError *error))completionHandler;

@end
