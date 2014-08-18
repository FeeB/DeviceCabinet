//
//  Person.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "Person.h"
#import "MD5Extension.h"

@implementation Person


-(void)createFullNameWithFirstName{
   self.fullName = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
