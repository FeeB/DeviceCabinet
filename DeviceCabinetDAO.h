//
//  DeviceCabinetDAO.h
//  Device Cabinet
//
//  Created by Fee Kristin Braun on 03.09.14.
//  Copyright (c) 2014 Fee Kristin Braun. All rights reserved.
//

#import "Device.h"
#import "Person.h"

@protocol DeviceCabinetDAO <NSObject>

@required
- (void)fetchDevicesWithCompletionHandler:(void (^)(NSArray *deviceObjects, NSError *error))completionHandler;
- (void)fetchDevicesWithDeviceName:(NSString *)deviceName completionHandler:(void (^)(NSArray *deviceObjects, NSError *error))completionHandler;
- (void)fetchDeviceWithDeviceId:(NSString *)deviceId completionHandler:(void (^)(Device *device, NSError *error))completionHandler;
- (void)fetchDevicesWithPerson:(Person *)person completionHandler:(void (^)(NSArray *devicesArray, NSError *error))completionHandler;
- (void)fetchDeviceRecordWithDevice:(Device *)device completionHandler:(void (^)(Device *device, NSError *error))completionHandler;
- (void)storeDevice:(Device *)device completionHandler:(void (^)(Device *device, NSError *error))completionHandler;

- (void)fetchPersonWithUsername:(NSString *)userName completionHandler:(void (^)(Person *person, NSError *error))completionHandler;
- (void)storePersonObjectAsReferenceWithDevice:(Device *)device person:(Person *)person completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler;
- (void)storePerson:(Person *)person completionHandler:(void (^)(Person *person, NSError *error))completionHandler;

- (void)deleteReferenceInDeviceWithDevice:(Device *)device completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler;

- (void)uploadAssetWithURL:(NSURL *)assetURL device:(Device *)device completionHandler:(void (^)(Device *device, NSError *error))completionHandler;

@end