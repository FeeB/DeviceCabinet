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
    // Do any additional setup after loading the view.
    // Initialize location manager and set ourselves as the delegate
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Create a NSUUID with the same UUID as the broadcasting beacon
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"f0018b9b-7509-4c31-a905-1a27d39c003c"];
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"identifier"];
    self.myBeaconRegion.notifyOnEntry = YES;
    self.myBeaconRegion.notifyOnExit = YES;
    self.myBeaconRegion.notifyEntryStateOnDisplay = YES;
    self.myBeaconRegion = [self.locationManager.monitoredRegions member:self.myBeaconRegion];
    
    // Tell location manager to start monitoring for the beacon region
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
    [self.locationManager requestStateForRegion:self.myBeaconRegion];
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLBeaconRegion*)region
{
    if ([region.identifier isEqualToString:@"identifier"]) {
        NSLog(@"Yes");
        self.statusLabel.text = @"Yes";
        [self viewWillAppear:YES];
    }
//    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
}

- (void)locationManager:(CLLocationManager*)manager didExitRegion:(CLBeaconRegion*)region
{
    if ([region.identifier isEqualToString:@"identifier"]) {
        NSLog(@"No");
        self.statusLabel.text = @"No";
        [self viewWillAppear:YES];
    }
//    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
//    self.statusLabel.text = @"No";
}

- (void)locationManager:(CLLocationManager*)manager
        didRangeBeacons:(NSArray*)beacons
               inRegion:(CLBeaconRegion*)region
{
    // Beacon found!
    self.statusLabel.text = @"Beacon found!";
    
    CLBeacon *foundBeacon = [beacons firstObject];
    
    // You can retrieve the beacon data from its properties
    NSString *uuid = foundBeacon.proximityUUID.UUIDString;
    NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
    NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
    NSLog(@"Beacon uuid: %@ major: %@ minor: %@", uuid, major, minor);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    NSLog(@"%d", state);
}


@end
