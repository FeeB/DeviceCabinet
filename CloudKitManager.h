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

- (void)fetchDevicesWithCompletionHandler:(void (^)(NSArray *deviceObjects))completionHandler;
- (void)fetchDevicesWithDeviceName:(NSString *)deviceName completionHandler:(void (^)(NSArray *deviceObjects))completionHandler;
- (void)fetchDevicesWithPersonID:(CKRecordID *)personID completionHandler:(void (^)(NSArray *devicesArray))completionHandler;

- (void)fetchPersonWithUsername:(NSString *)userName completionHandler:(void (^)(Person *person))completionHandler;
- (void)storePersonObjectAsReferenceWithDeviceID:(CKRecordID *)deviceID personID:(CKRecordID *)personID completionHandler:(void (^)())completionHandler;
- (void)storePerson:(Person *)person completionHandler:(void (^)())completionHandler;

- (void)deleteReferenceInDeviceWithDeviceID:(CKRecordID *)deviceID completionHandler:(void (^)())completionHandler;

- (void)resetPasswordFromPersonObjectWithPersonID:(CKRecordID *)personID password:(NSString *)password completionHandler:(void (^)(CKRecord *record))completionHandler;

@end
