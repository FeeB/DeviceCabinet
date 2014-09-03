//
//  Person.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "Person.h"

@implementation Person


- (void)createFullNameWithFirstName {
   self.fullName = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (NSDictionary *)toJson {
    NSData *json;
    NSError *error = nil;
    [self createFullNameWithFirstName];
    NSDictionary *dictionary = @{@"firstName" : self.firstName, @"lastName" : self.lastName, @"username" : self.userName, @"fullName" : self.fullName, @"hasBookedDevice" : self.hasBookedDevice ? @"Yes" : @"No"};
    
//    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
//        // Serialize the dictionary
//        json = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
//        
//        // If no errors, let's view the JSON
//        if (json != nil && error == nil)
//        {
//            NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
//            
//            NSLog(@"JSON: %@", jsonString);
//        }
//    }
    return dictionary;
}

@end
