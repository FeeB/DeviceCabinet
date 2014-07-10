//
//  Device.h
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Person;

@interface Device : NSObject

@property NSString *deviceName;
@property NSString *category;
@property BOOL isBooked;
@property UIImage *image;
@property Person *bookedFromPerson;

@end
