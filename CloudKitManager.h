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

- (void)fetchDeviceRecordsWithType:(NSString *)recordType completionHandler:(void (^)(NSArray *records))completionHandler;
-(void)fetchDeviceRecordWithDeviceName:(NSString *)recordName completionHandler:(void (^)(NSArray *records))completionHandler;
-(void)fetchPersonRecordWithPersonName:(NSString *)recordName completionHandler:(void (^)(NSArray *records))completionHandler;
-(Person *)getBackPersonObjektWithRecord:(CKRecord *)record;
-(Device *)getBackDeviceObjektWithRecord:(CKRecord *)record;
-(void)fetchPersonRecordWithID:(CKRecordID *)recordID completionHandler:(void (^)(CKRecord *record))completionHandler;
-(void)storePersonObjectAsReferenceWithDeviceID:(CKRecordID *)deviceID personIf:(CKRecordID *)personID completionHandler:(void (^)(CKRecord *record))completionHandler;

@end
