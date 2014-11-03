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
    return @{@"device_name" : self.deviceName, @"device_id" : self.deviceId, @"category" : self.category, @"system_version" : self.systemVersion, @"is_booked" : self.isBookedByPerson ? @"YES" : @"NO", @"device_type" : self.deviceType};
}

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super init];
    if (self) {
        self.deviceName = [json valueForKey:@"device_name"];
        self.deviceId = [json valueForKey:@"device_id"];
        self.category = [json valueForKey:@"category"];
        self.deviceRecordId = [json valueForKey:@"id"];
        self.systemVersion = [json valueForKey:@"system_version"];
        if ([json valueForKey:@"image_url"] != [NSNull null]) {
            self.imageUrl = [NSURL URLWithString:[json valueForKey:@"image_url"]];
        }
        self.bookedByPerson = [[json valueForKey:@"is_booked"] isEqualToString:@"YES"] ? YES : NO;
        self.bookedByPersonId = [json valueForKey:@"person_id"];
        self.deviceType = [json valueForKey:@"device_type"];
        
        NSDictionary *personDictionary = [json valueForKey:@"person"];
        self.bookedByPersonFullName = [personDictionary valueForKey:@"full_name"];
    }
    return self;
}

- (Device *)getBackDeviceObjectFromJson:(NSDictionary *)json{
    Device *device = [[Device alloc] init];
    return device;
}

@end
