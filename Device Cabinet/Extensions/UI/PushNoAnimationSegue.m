//
//  PushNoAnimationSegue.m
//  Device Cabinet
//
//  Created by Fee Kristin Braun on 15.11.14.
//  Copyright (c) 2014 Fee Kristin Braun. All rights reserved.
//

#import "PushNoAnimationSegue.h"
#import "DecisionViewController.h"

@implementation PushNoAnimationSegue

- (void) perform{
    if ([[self destinationViewController] isKindOfClass:[DecisionViewController class]]) {
        [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:NO];
    } else {
        UINavigationController *navigationController = (UINavigationController *)[self destinationViewController];
        UIViewController *controller = navigationController.topViewController;
        [[[self sourceViewController] navigationController] pushViewController:controller animated:NO];
    }
}

@end
