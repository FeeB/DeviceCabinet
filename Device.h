//
//  Device.h
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

@class Person;

@interface Device : NSObject

@property NSString *deviceName;
@property NSString *category;
@property (getter=isBookedByPerson) BOOL bookedByPerson;
@property NSString *bookedByPersonUsername;
@property NSString *bookedByPersonId;
@property NSString *bookedByPersonFullName;
@property CKRecordID *recordId;
@property NSString *deviceId;
@property NSString *systemVersion;
@property NSString *deviceRecordId;
@property NSURL *imageUrl;

@property CKRecordID *bookedByPersonIdCloudKit;

- (instancetype)initWithJson:(NSDictionary *)json;
- (NSDictionary *)toDictionary;

@end
