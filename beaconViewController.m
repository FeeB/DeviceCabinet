//
//  beaconViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 07.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "beaconViewController.h"

@interface beaconViewController ()

@end

@implementation beaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize location manager and set ourselves as the delegate
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    
    // Create a NSUUID with the same UUID as the broadcasting beacon
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"f0018b9b-7509-4c31-a905-1a27d39c003c"];
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"identifier"];
    self.myBeaconRegion.notifyOnEntry = YES;
    self.myBeaconRegion.notifyOnExit = YES;
    self.myBeaconRegion.notifyEntryStateOnDisplay = YES;
    
    // Tell location manager to start monitoring for the beacon region
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLBeaconRegion*)region {
    if ([region.identifier isEqualToString:@"identifier"]) {
        self.statusLabel.text = @"Yes";
    }
}

- (void)locationManager:(CLLocationManager*)manager didExitRegion:(CLBeaconRegion*)region {
    if ([region.identifier isEqualToString:@"identifier"]) {
        self.statusLabel.text = @"No";
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if (state == CLRegionStateInside) {
        NSLog(@"CLRegionStateInside");
    } else if (state == CLRegionStateOutside) {
        NSLog(@"CLRegionStateOutside");
    } else {
        NSLog(@"CLRegionStateUnknown");
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"%@", error);
}


@end
