//
//  Person.h
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

@class Device;

@interface Person : NSObject

@property NSString *firstName;
@property NSString *lastName;
@property BOOL hasBookedDevice;
@property CKRecordID *recordId;
@property NSString *username;
@property (readonly) NSString *fullName;
@property NSString *personRecordId;

- (instancetype)initWithJson:(NSDictionary *)json;
- (NSDictionary *)toDictionary;

@end
