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
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
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

- (void)locationManager:(CLLocationManager*)manager
        didRangeBeacons:(NSArray*)beacons
               inRegion:(CLBeaconRegion*)region {
    // Beacon found!
    self.statusLabel.text = @"Beacon found!";
    
    CLBeacon *foundBeacon = [beacons firstObject];
    
    // You can retrieve the beacon data from its properties
    NSString *uuid = foundBeacon.proximityUUID.UUIDString;
    NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
    NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
    NSString *proximity;
    switch (foundBeacon.proximity) {
        case CLProximityUnknown:
            proximity = @"Unknown";
            break;
        case CLProximityImmediate:
            proximity = @"Immediate";
            break;
        case CLProximityNear:
            proximity = @"Near";
        [[[UIAlertView alloc] initWithTitle:@"Gerät ausgeliehen" message:@"Gerät ist nicht mehr im Schrank" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            break;
        case CLProximityFar:
            proximity = @"Far";
            break;
    }
    NSLog(@"Beacon uuid: %@ major: %@ minor: %@, proximity: %@", uuid, major, minor, proximity);
    
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
