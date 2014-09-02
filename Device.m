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

- (NSData *)toJson {
    NSError *error = nil;
    NSData *json;
    NSData *personJson = [self.bookedFromPerson toJson];
    
    NSDictionary *dictionary = @{@"deviceName" : self.deviceName, @"deviceId" : self.deviceId, @"category" : self.category, @"isBookedFrom" : self.isBooked ? personJson : @"", @"deviceId" : self.deviceId, @"systemVersion" : self.systemVersion, @"isBooked" : self.isBooked ? @"Yes" : @"No"};
    
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
        // Serialize the dictionary
        json = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        // If no errors, let's view the JSON
        if (json != nil && error == nil)
        {
            NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            
            NSLog(@"JSON: %@", jsonString);
        }
    }
    return json;
}

@end
