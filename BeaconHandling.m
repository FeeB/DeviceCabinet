//
//  BeaconHandling.m
//  Device Cabinet
//
//  Created by Braun,Fee on 06.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "BeaconHandling.h"

@implementation BeaconHandling

- (void)startRanging {
    
    self.beaconManager = [[BIBeaconManager alloc] init];
    NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:@"F001A0A0-7509-4C31-A905-1A27D39C003C"];
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID identifier:@"My Beacon Region"];
    
    [self.beaconManager ];
}

@end
