//
//  Device.h
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@interface Device : NSObject

@property NSString *deviceName;
@property NSString *type;
@property (getter=isBookedByPerson) BOOL bookedByPerson;
@property NSString *bookedByPersonId;
@property NSString *bookedByPersonFullName;
@property NSString *deviceUdId;
@property NSString *systemVersion;
@property NSString *deviceId;
@property NSURL *imageUrl;
@property NSString *deviceModel;

- (instancetype)initWithJson:(NSDictionary *)json;
- (NSDictionary *)toDictionary;

@end
