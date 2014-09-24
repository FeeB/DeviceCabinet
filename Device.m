//
//  Device.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "Device.h"
#import "Person.h"

@implementation Device

- (NSDictionary *)toDictionary {
    return @{@"deviceName" : self.deviceName, @"deviceId" : self.deviceId, @"category" : self.category, @"deviceId" : self.deviceId, @"systemVersion" : self.systemVersion, @"isBooked" : self.isBookedByPerson ? @"YES" : @"NO"};
}

- (instancetype)initWithJson:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        self.deviceName = [json valueForKey:@"deviceName"];
        self.deviceId = [json valueForKey:@"deviceId"];
        self.category = [json valueForKey:@"category"];
        self.deviceRecordId = [json valueForKey:@"id"];
        self.systemVersion = [json valueForKey:@"systemVersion"];
        self.imageUrl = [NSURL URLWithString:[json valueForKey:@"image_url"]];
        self.bookedByPerson = [[json valueForKey:@"isBooked"] isEqualToString:@"YES"] ? YES : NO;
        self.bookedByPersonId = [json valueForKey:@"person_id"];
        
        NSDictionary *personDictionary = [json valueForKey:@"person"];
        self.bookedByPersonUsername = [personDictionary valueForKey:@"username"];
        self.bookedByPersonFullName = [personDictionary valueForKey:@"fullName"];
    }
    return self;
}

- (Device *)getBackDeviceObjectFromJson:(NSDictionary *)json{
    Device *device = [[Device alloc] init];
    return device;
}

@end
