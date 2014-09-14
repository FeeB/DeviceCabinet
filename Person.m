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

- (NSDictionary *)toDictionary {
    NSDictionary *dictionary = @{@"firstName" : self.firstName, @"lastName" : self.lastName, @"username" : self.username, @"fullName" : self.fullName, @"hasBookedDevice" : self.hasBookedDevice ? @"Yes" : @"No"};
  
    return dictionary;
}

@end
