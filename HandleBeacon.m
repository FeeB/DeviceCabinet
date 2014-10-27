//
//  HandleBeacon.m
//  Device Cabinet
//
//  Created by Braun,Fee on 06.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "HandleBeacon.h"
#import <CoreLocation/CoreLocation.h>
#import "UserDefaults.h"
#import "AppDelegate.h"
#import "RailsApiErrorMapper.h"
#import "Device.h"

@implementation HandleBeacon


@synthesize locationManager;

- (void)searchForBeacon
{
    // Create a NSUUID with the same UUID as the broadcasting beacon
    NSUUID *beaconUuid = [[NSUUID alloc] initWithUUIDString:@"f0018b9b-7509-4c31-a905-1a27d39c003c"];
    NSString *beaconIdentifier = @"deviceCabinetBeacon";
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUuid identifier:beaconIdentifier];
    self.myBeaconRegion.notifyOnEntry = YES;
    self.myBeaconRegion.notifyOnExit = YES;
    self.myBeaconRegion.notifyEntryStateOnDisplay = YES;
    
    // New iOS 8 request for Always Authorization, required for iBeacons to work!
    self.locationManager = [[CLLocationManager alloc] init];
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
    
    [self checkCurrentDevice];
}

- (void)sendLocalNotificationWithMessage:(NSString*)message {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = message;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLBeaconRegion*)region {
    [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager*)manager didExitRegion:(CLBeaconRegion*)region {
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    if (!self.deviceObject.isBookedByPerson) {
        [self sendLocalNotificationWithMessage:@"Bitte leihe das Gerät aus!"];
    }
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region {
    
    NSString *deviceMessage = @"";
    
    if(beacons.count > 0) {
        CLBeacon *nearestBeacon = beacons.firstObject;
        
        if(nearestBeacon.proximity == self.lastProximity ||
           nearestBeacon.proximity == CLProximityUnknown) {
            return;
        }
        
        if (nearestBeacon.proximity == CLProximityNear) {
            if (!self.deviceObject.isBookedByPerson) {
                deviceMessage = @"Bitte leihe das Gerät aus!";
            }
        } else if (nearestBeacon.proximity == CLProximityImmediate ) {
            if (self.deviceObject.isBookedByPerson) {
                deviceMessage = @"Willst du das Gerät zurückgeben?";
            }
        }
        
        self.beforeLastProximity = self.lastProximity;
        self.lastProximity = nearestBeacon.proximity;
        
    } else {
        if (!self.deviceObject.isBookedByPerson) {
            deviceMessage = @"Bitte leihe das Gerät aus!";
        }
    }
    
    [self sendLocalNotificationWithMessage:deviceMessage];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)checkCurrentDevice {
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    NSString *userType = [userDefaults getUserType];
    if ([userType isEqualToString:@"device"]) {
        [AppDelegate.dao fetchDeviceWithDeviceId:userDefaults.getUserIdentifier completionHandler:^(Device *device, NSError *error) {
            if (error) {
                if (![RailsApiErrorMapper itemNotFoundInDatabaseError]) {
                    [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                               message:error.localizedRecoverySuggestion
                                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                }
            } else {
                self.deviceObject = [[Device alloc]init];
                self.deviceObject = device;
            }
        }];
    }
}

@end
