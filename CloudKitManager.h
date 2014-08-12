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

- (void)fetchDeviceRecordsWithType:(NSString *)recordType completionHandler:(void (^)(NSArray *deviceObjects))completionHandler;
-(void)fetchDeviceRecordWithDeviceName:(NSString *)deviceName completionHandler:(void (^)(NSArray *deviceObjects))completionHandler;
-(void)fetchPersonRecordWithUserName:(NSString *)userName completionHandler:(void (^)(NSArray *personObjects))completionHandler;
-(Person *)getBackPersonObjektWithRecord:(CKRecord *)record;
-(Device *)getBackDeviceObjektWithRecord:(CKRecord *)record;
-(void)fetchPersonRecordWithID:(CKRecordID *)deviceID completionHandler:(void (^)(Person *record))completionHandler;
-(void)storePersonObjectAsReferenceWithDeviceID:(CKRecordID *)deviceID personID:(CKRecordID *)personID completionHandler:(void (^)(CKRecord *record))completionHandler;
-(void)getBackAllBookedDevicesWithPersonID:(CKRecordID *)personID completionHandler:(void (^)(NSArray *devicesArray))completionHandler;

@end
