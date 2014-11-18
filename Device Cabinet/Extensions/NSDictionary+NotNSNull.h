//
//  NSDictionary+NotNSNull.h
//  Device Cabinet
//
//  Created by Fee Kristin Braun on 18.11.14.
//  Copyright (c) 2014 Fee Kristin Braun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NotNSNull)

- (id)objectForKeyNotNSNull:(id)key;

@end
