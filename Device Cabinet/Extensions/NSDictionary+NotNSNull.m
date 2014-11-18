//
//  NSDictionary+NotNSNull.m
//  Device Cabinet
//
//  Created by Fee Kristin Braun on 18.11.14.
//  Copyright (c) 2014 Fee Kristin Braun. All rights reserved.
//

#import "NSDictionary+NotNSNull.h"

@implementation NSDictionary (NotNSNull)

- (id)objectForKeyNotNSNull:(id)key
{
    id object = [self objectForKey:key];
    return object == [NSNull null] ? nil : object;
}

@end
