//
//  HandleBeacon.m
//  Device Cabinet
//
//  Created by Braun,Fee on 06.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "HandleBeacon.h"
#import <BEACONinsideSDK/BEACONinsideSDK.h>
#import "BeaconNotificationRegion.h"
#import "BeaconDemoAppDelegate.h"

@implementation HandleBeacon

-(void)registerNotification {
    BeaconNotificationRegion* region = [[BeaconNotificationRegion alloc] init];
    
    // Copy our UI values into the new region object
    region.beaconUUID = BIBeaconDefaultProximityUUID;
    
    region.helloMessage = @"Hello";
    region.goodbyeMessage = @"Bye";
    
    
    
    BeaconDemoAppDelegate *delegate = [[BeaconDemoAppDelegate alloc] init];
    
    // If this is an update, we unregister the old region first
    if (self.detailItem)
    {
        // Remove the old region
        [delegate removeNotificationRegion:_detailItem];
    }
    
    // Register the region
    [delegate addNotificationRegion:region];
    
    [self sendMessagesWithRegion:region];
}

- (void)sendMessagesWithRegion:(BeaconNotificationRegion*)region {
//    BeaconDemoAppDelegate *delegate = [[BeaconDemoAppDelegate alloc] init];
//    BeaconNotificationRegion *region = [delegate notificationRegionAtIndex:0];
    
    // Convert beacon proximity to an English description
    if (region.lastState == CLRegionStateInside)
    {
        // We're in the region, so use proximity values from the last ranging
        // operation to update the view
        NSArray* proximityDescriptions = @[ @"Unknown", @"Immediate", @"Near", @"Far"];
        NSLog(@"%@", proximityDescriptions[region.lastProximity]);
        NSLog(@"%.2fm", region.lastAccuracy);
//        NSLog([NSString stringWithFormat:@"%lddB", (long)region.lastRSSI]);
    }
    else
    {
        // We're outside the region, let the user know
        NSLog(@"Not In Range");
    }

}

@end
