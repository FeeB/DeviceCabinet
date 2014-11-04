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
@import AudioToolbox;

@implementation HandleBeacon


@synthesize locationManager;

- (void)searchForBeacon
{
    // Create a NSUUID with the same UUID as the broadcasting beacon
    NSUUID *beaconUuid = [[NSUUID alloc] initWithUUIDString:@"f0018b9b-7509-4c31-a905-1a27d39c003c"];
    NSString *beaconIdentifier = @"deviceCabinetBeacon";
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUuid identifier:beaconIdentifier];
    
    // New iOS 8 request for Always Authorization, required for iBeacons to work!
    self.locationManager = [[CLLocationManager alloc] init];
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    self.locationManager.activityType = CLActivityTypeFitness;
    
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    self.userIdentifier = [userDefaults getUserIdentifier];
    self.userType = [userDefaults getUserType];

}

- (void)sendLocalNotificationWithMessage:(NSString*)message {
    if ([[UIApplication sharedApplication] applicationState] !=  UIApplicationStateInactive && [[UIApplication sharedApplication] applicationState] !=  UIApplicationStateActive){
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = message;
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    } else {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
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
    
    if(beacons.count > 0) {
        CLBeacon *nearestBeacon = beacons.firstObject;
        
        if(nearestBeacon.proximity == self.lastProximity ||
           nearestBeacon.proximity == CLProximityUnknown) {
            return;
        }
        
        if ([self.userType isEqualToString:@"device"]) {
            [self checkCurrentDeviceWithCompletionHandler:^(Device *device, NSError *error) {
                self.deviceObject = device;
                
                if (device.isBookedByPerson) {
                    if (nearestBeacon.proximity == CLProximityImmediate ) {
                        [self sendLocalNotificationWithMessage:@"Willst du das Gerät zurückgeben?"];
                    }
                } else {
                    if (nearestBeacon.proximity == CLProximityNear || nearestBeacon.proximity == CLProximityFar) {
                        [self sendLocalNotificationWithMessage:@"Bitte leihe das Gerät aus!"];
                    }
                }
                self.lastProximity = nearestBeacon.proximity;
            }];
        } else {
            if (!self.deviceObject.isBookedByPerson) {
                [self sendLocalNotificationWithMessage:@"Bitte leihe das Gerät aus!"];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)checkCurrentDeviceWithCompletionHandler:(void (^)(Device *, NSError *))completionHandler  {
    [AppDelegate.dao fetchDeviceWithDeviceId:self.userIdentifier completionHandler:^(Device *device, NSError *error) {
        if (error) {
            if (![RailsApiErrorMapper itemNotFoundInDatabaseError]) {
                [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                           message:error.localizedRecoverySuggestion
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(device, nil);
            });
        }
    }];
}

@end
