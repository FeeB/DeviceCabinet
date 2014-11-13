//
//  Person.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (instancetype)initWithJson:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        self.firstName = [json valueForKey:@"first_name"];
        self.lastName = [json valueForKey:@"last_name"];
        self.personId = [json valueForKey:@"id"];
        
        if ([json valueForKey:@"has_booked_device"] != (id)[NSNull null]) {
            self.hasBookedDevice = YES;
        } else {
            self.hasBookedDevice = NO;
        }

    }
    return self;
}

- (NSDictionary *)toDictionary {
    return @{@"first_name" : self.firstName, @"last_name" : self.lastName, @"full_name" : self.fullName, @"has_booked_device" : self.hasBookedDevice ? @"Yes" : @"No"};
}

@end
