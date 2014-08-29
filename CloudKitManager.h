//
//  CloudKitManager.h
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import "Person.h"
#import "Device.h"

@interface CloudKitManager : NSObject

- (void)fetchDevicesWithCompletionHandler:(void (^)(NSArray *deviceObjects, NSError *error))completionHandler;
- (void)fetchDevicesWithDeviceName:(NSString *)deviceName completionHandler:(void (^)(NSArray *deviceObjects, NSError *error))completionHandler;
- (void)fetchDeviceWithDeviceId:(NSString *)deviceId completionHandler:(void (^)(Device *device, NSError *error))completionHandler;
- (void)fetchDevicesWithPersonID:(CKRecordID *)personID completionHandler:(void (^)(NSArray *devicesArray, NSError *error))completionHandler;
- (void)fetchDeviceRecordWithID:(CKRecordID *)deviceRecordID completionHandler:(void (^)(Device *device, NSError *error))completionHandler;
- (void)storeDevice:(Device *)device completionHandler:(void (^)(NSError *error))completionHandler;

- (void)fetchPersonWithUsername:(NSString *)userName completionHandler:(void (^)(Person *person, NSError *error))completionHandler;
- (void)storePersonObjectAsReferenceWithDeviceID:(CKRecordID *)deviceID personID:(CKRecordID *)personID completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler;
- (void)storePerson:(Person *)person completionHandler:(void (^)(NSError *error))completionHandler;

- (void)deleteReferenceInDeviceWithDeviceID:(CKRecordID *)deviceID completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler;

- (void)uploadAssetWithURL:(NSURL *)assetURL deviceId:(CKRecordID *)deviceId completionHandler:(void (^)(Device *device, NSError *error))completionHandler;


@end
