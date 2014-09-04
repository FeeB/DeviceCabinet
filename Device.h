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
@property BOOL isBooked;
@property UIImage *image;
@property Person *bookedFromPerson;
@property CKRecordID *recordId;
@property NSString *deviceId;
@property NSString *systemVersion;
@property NSString *person_id;
@property NSInteger *deviceRecordId;

- (NSDictionary *)toDictionary;

@end
