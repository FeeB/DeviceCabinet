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
@property NSString *userName;
@property NSString *fullName;

- (void)createFullNameWithFirstName;
- (NSData *)toJson;

@end
