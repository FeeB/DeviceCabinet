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



- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.deviceId forKey:@"deviceId"];
    [encoder encodeObject:self.deviceName forKey:@"deviceName"];
    [encoder encodeObject:self.deviceType forKey:@"deviceType"];
    [encoder encodeObject:self.deviceRecordId forKey:@"deviceRecordId"];
    [encoder encodeBool:self.bookedByPerson forKey:@"bookedByPerson"];
    [encoder encodeObject:self.bookedByPersonFullName forKey:@"bookedByPersonFullName"];
    [encoder encodeObject:self.bookedByPersonId forKey:@"bookedByPersonId"];
    [encoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [encoder encodeObject:self.category forKey:@"category"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.deviceId = [decoder decodeObjectForKey:@"deviceId"];
        self.deviceName = [decoder decodeObjectForKey:@"deviceName"];
        self.deviceType = [decoder decodeObjectForKey:@"deviceType"];
        self.deviceRecordId = [decoder decodeObjectForKey:@"deviceRecordId"];
        self.bookedByPerson = [decoder decodeBoolForKey:@"bookedByPerson"];
        self.bookedByPersonFullName = [decoder decodeObjectForKey:@"bookedByPersonFullName"];
        self.bookedByPersonId = [decoder decodeObjectForKey:@"bookedByPersonId"];
        self.imageUrl = [decoder decodeObjectForKey:@"imageUrl"];
        self.category = [decoder decodeObjectForKey:@"category"];
    }
    return self;
}

@end
