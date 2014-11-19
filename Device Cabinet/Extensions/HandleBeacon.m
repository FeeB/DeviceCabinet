//
//  HandleBeacon.m
//  Device Cabinet
//
//  Created by Braun,Fee on 06.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "HandleBeacon.h"
#import <CoreLocation/CoreLocation.h>
#import "UserDefaultsWrapper.h"
#import "AppDelegate.h"
#import "RailsApiErrorMapper.h"
#import "Device.h"
@import AudioToolbox;

@interface HandleBeacon ()

@property (nonatomic) CLBeaconRegion *myBeaconRegion;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property CLProximity lastProximity;
@property (nonatomic) Device *device;
@property (nonatomic, assign) bool notificationToReturnDeviceWasSend;
@property (nonatomic, assign) bool notificationToBookDeviceWasSend;

@end

@implementation HandleBeacon

- (void)searchForBeacon {
    if ([UserDefaultsWrapper isLocalDevice]) {
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
        
        [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
        [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
        
        self.device = [UserDefaultsWrapper getLocalDevice];
    }
}

- (void)sendLocalNotificationWithMessage:(NSString*)message {
    UIApplicationState applicationState = [[UIApplication sharedApplication] applicationState];
    if (applicationState != UIApplicationStateInactive && applicationState !=  UIApplicationStateActive) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = message;
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLBeaconRegion*)region {
    NSLog(@"Device did Enter Region");
    
    [self checkLocalDeviceWithCompletionHandler:^(Device *device, NSError *error) {
        if (device.isBookedByPerson && !self.notificationToReturnDeviceWasSend) {
            [self sendLocalNotificationWithMessage:NSLocalizedString(@"NOTIFICATION_RETURN_LABEL", nil)];
            self.notificationToReturnDeviceWasSend = YES;
            self.notificationToBookDeviceWasSend = NO;
            NSLog(@"Return notification was send from didEnter");
        }
    }];
    
    [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager*)manager didExitRegion:(CLBeaconRegion*)region {
    NSLog(@"Device did Exit Region");
    
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    if (!self.device.isBookedByPerson && !self.notificationToBookDeviceWasSend) {
        [self sendLocalNotificationWithMessage:NSLocalizedString(@"NOTIFICATION_BOOK_LABEL", nil)];
        self.notificationToBookDeviceWasSend = YES;
        self.notificationToReturnDeviceWasSend = NO;
        NSLog(@"Book notification was send from didExit");
    }
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region {
    
    NSLog(@"rangeBeacons");
    
    if(beacons.count > 0) {
        CLBeacon *nearestBeacon = beacons.firstObject;
        
        if(nearestBeacon.proximity == self.lastProximity || nearestBeacon.proximity == CLProximityUnknown) {
            NSLog(@"same proximity");
            return;
        }
        
        switch (nearestBeacon.proximity) {
            case CLProximityImmediate:
                NSLog(@"Immediate");
                break;
            case CLProximityNear:
                NSLog(@"Near");
                break;
            case CLProximityFar:
                NSLog(@"Far");
                break;
            case CLProximityUnknown:
                NSLog(@"Unknown");
                break;
            default:
                break;
        }
        
        [self checkLocalDeviceWithCompletionHandler:^(Device *device, NSError *error) {
            if (self.device.isBookedByPerson != device.isBookedByPerson) {
                self.notificationToBookDeviceWasSend = NO;
                self.notificationToReturnDeviceWasSend = NO;
            }
            self.device = device;
            
            if (self.device.isBookedByPerson) {
                if (!self.notificationToReturnDeviceWasSend && (nearestBeacon.proximity == CLProximityImmediate || nearestBeacon.proximity == CLProximityNear)) {
                    [self sendLocalNotificationWithMessage:NSLocalizedString(@"NOTIFICATION_RETURN_LABEL", nil)];
                    self.notificationToReturnDeviceWasSend = YES;
                    self.notificationToBookDeviceWasSend = NO;
                    NSLog(@"Return notification was send from region immediate or near");
                }
            } else {
                if (!self.notificationToBookDeviceWasSend && nearestBeacon.proximity == CLProximityFar) {
                    [self sendLocalNotificationWithMessage:NSLocalizedString(@"NOTIFICATION_BOOK_LABEL", nil)];
                    self.notificationToBookDeviceWasSend = YES;
                    self.notificationToReturnDeviceWasSend = NO;
                    NSLog(@"Book notification was send from region far");
                }
            }
            self.lastProximity = nearestBeacon.proximity;
        }];
        
    } else {
        if (!self.device.isBookedByPerson && !self.notificationToBookDeviceWasSend) {
            [self sendLocalNotificationWithMessage:NSLocalizedString(@"NOTIFICATION_BOOK_LABEL", nil)];
            self.notificationToBookDeviceWasSend = YES;
            self.notificationToReturnDeviceWasSend = NO;
            NSLog(@"Book notification was send from when no beacons were found");

        }
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)checkLocalDeviceWithCompletionHandler:(void (^)(Device *, NSError *))completionHandler  {
    [AppDelegate.dao fetchDeviceWithDevice:self.device completionHandler:^(Device *device, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(device, nil);
            });
        }
    }];
}

@end
