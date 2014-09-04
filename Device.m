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
    NSDictionary *dictionary = @{@"deviceName" : self.deviceName, @"deviceId" : self.deviceId, @"category" : self.category, @"deviceId" : self.deviceId, @"systemVersion" : self.systemVersion, @"isBooked" : self.isBooked ? @"YES" : @"NO"};
    
    return dictionary;
}

@end
