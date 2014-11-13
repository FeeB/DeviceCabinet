//
//  DeviceCabinetDAO.h
//  Device Cabinet
//
//  Created by Fee Kristin Braun on 03.09.14.
//  Copyright (c) 2014 Fee Kristin Braun. All rights reserved.
//

#import "Device.h"
#import "Person.h"

@protocol DeviceCabinetDao <NSObject>

@required
- (void)fetchDevicesWithCompletionHandler:(void (^)(NSArray *deviceObjects, NSError *error))completionHandler;
- (void)fetchDeviceWithDeviceId:(NSString *)deviceId completionHandler:(void (^)(Device *device, NSError *error))completionHandler;
- (void)fetchDeviceRecordWithDevice:(Device *)device completionHandler:(void (^)(Device *device, NSError *error))completionHandler;
- (void)storeDevice:(Device *)device completionHandler:(void (^)(Device *device, NSError *error))completionHandler;

- (void)storePersonObjectAsReferenceWithDevice:(Device *)device person:(Person *)person completionHandler:(void (^)(NSError *error))completionHandler;
- (void)storePerson:(Person *)person completionHandler:(void (^)(Person *person, NSError *error))completionHandler;

- (void)deleteReferenceInDeviceWithDevice:(Device *)device completionHandler:(void (^)(NSError *error))completionHandler;

@end