//
//  Device.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "Device.h"
#import "Person.h"
#import "NSDictionary+NotNSNull.h"

@implementation Device

- (NSDictionary *)toDictionary {
    NSMutableDictionary *deviceDictionary = @{@"device_name" : self.deviceName, @"category" : self.type, @"system_version" : self.systemVersion, @"is_booked" : self.isBookedByPerson ? @"YES" : @"NO", @"device_type" : self.deviceType}.mutableCopy;
    
    if (self.deviceUdId) {
        [deviceDictionary setValue:self.deviceUdId forKey:@"device_id"];
    }
    
    return deviceDictionary;
}

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super init];
    if (self) {
        self.deviceName = [json objectForKeyNotNSNull:@"device_name"];
        self.deviceUdId = [json objectForKeyNotNSNull:@"device_id"];
        self.type = [json objectForKeyNotNSNull:@"category"];
        self.deviceId = [json objectForKeyNotNSNull:@"id"];
        self.systemVersion = [json objectForKeyNotNSNull:@"system_version"];
        self.bookedByPerson = [[json objectForKeyNotNSNull:@"is_booked"] isEqualToString:@"YES"] ? YES : NO;
        self.bookedByPersonId = [json objectForKeyNotNSNull:@"person_id"];
        self.deviceType = [json objectForKeyNotNSNull:@"device_type"];
        self.bookedByPersonFullName = [[json objectForKeyNotNSNull:@"person"] objectForKeyNotNSNull:@"full_name"];
        
        NSString *imageUrlString = [json objectForKeyNotNSNull:@"image_url"];
        if (imageUrlString) {
            self.imageUrl = [NSURL URLWithString:imageUrlString];
        }
    }
    return self;
}



- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.deviceUdId forKey:@"deviceId"];
    [encoder encodeObject:self.deviceName forKey:@"deviceName"];
    [encoder encodeObject:self.deviceType forKey:@"deviceType"];
    [encoder encodeObject:self.deviceId forKey:@"deviceRecordId"];
    [encoder encodeBool:self.bookedByPerson forKey:@"bookedByPerson"];
    [encoder encodeObject:self.bookedByPersonFullName forKey:@"bookedByPersonFullName"];
    [encoder encodeObject:self.bookedByPersonId forKey:@"bookedByPersonId"];
    [encoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [encoder encodeObject:self.type forKey:@"category"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.deviceUdId = [decoder decodeObjectForKey:@"deviceId"];
        self.deviceName = [decoder decodeObjectForKey:@"deviceName"];
        self.deviceType = [decoder decodeObjectForKey:@"deviceType"];
        self.deviceId = [decoder decodeObjectForKey:@"deviceRecordId"];
        self.bookedByPerson = [decoder decodeBoolForKey:@"bookedByPerson"];
        self.bookedByPersonFullName = [decoder decodeObjectForKey:@"bookedByPersonFullName"];
        self.bookedByPersonId = [decoder decodeObjectForKey:@"bookedByPersonId"];
        self.imageUrl = [decoder decodeObjectForKey:@"imageUrl"];
        self.type = [decoder decodeObjectForKey:@"category"];
    }
    return self;
}

@end
