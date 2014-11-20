//
//  apiExtension.h
//  Device Cabinet
//
//  Created by Braun,Fee on 02.09.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

@class Device;
@class Person;
@interface RailsApiDao : NSObject


- (void)fetchDevicesWithCompletionHandler:(void (^)(NSArray *deviceObjects, NSError *error))completionHandler;
- (void)fetchDeviceWithDeviceUdId:(NSString *)deviceId completionHandler:(void (^)(Device *device, NSError *error))completionHandler;
- (void)fetchDeviceWithDevice:(Device *)device completionHandler:(void (^)(Device *device, NSError *error))completionHandler;
- (void)storeDevice:(Device *)device completionHandler:(void (^)(Device *device, NSError *error))completionHandler;
- (void)deleteDevice:(Device *)device completionHandler:(void (^)( NSError *))completionHandler;

- (void)fetchPeopleWithCompletionHandler:(void (^)(NSArray *personObjects, NSError *error))completionHandler;
- (void)storePerson:(Person *)person completionHandler:(void (^)(Person *person, NSError *error))completionHandler;
- (void)deletePerson:(Person *)person completionHandler:(void (^)( NSError *))completionHandler;
- (void)storePersonObjectAsReferenceWithDevice:(Device *)device person:(Person *)person completionHandler:(void (^)(NSError *error))completionHandler;
- (void)deleteReferenceInDeviceWithDevice:(Device *)device completionHandler:(void (^)(NSError *error))completionHandler;

- (void)uploadImage:(UIImage*)image forDevice:(Device *)device completionHandler:(void (^)(NSError *))completionHandler;
- (void)updateSystemVersion:(Device *)device completionHandler:(void (^)(NSError *))completionHandler;


@end
