//
//  PushNoAnimationSegue.m
//  Device Cabinet
//
//  Created by Fee Kristin Braun on 15.11.14.
//  Copyright (c) 2014 Fee Kristin Braun. All rights reserved.
//

#import "PushNoAnimationSegue.h"

@implementation PushNoAnimationSegue

- (void) perform{
    [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:NO];
}

@end
