//
//  Person.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "Person.h"
#import "NSDictionary+NotNSNull.h"

@implementation Person

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (instancetype)initWithJson:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        self.firstName = [json objectForKeyNotNSNull:@"first_name"];
        self.lastName = [json objectForKeyNotNSNull:@"last_name"];
        self.personId = [json objectForKeyNotNSNull:@"id"];
    }
    return self;
}

- (NSDictionary *)toDictionary {
    return @{@"first_name" : self.firstName, @"last_name" : self.lastName, @"full_name" : self.fullName};
}

@end
