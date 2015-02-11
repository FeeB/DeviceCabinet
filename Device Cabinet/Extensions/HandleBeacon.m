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
#import "RESTApiErrorMapper.h"
#import "Device.h"
#import "OverviewViewController.h"
#import <UIKit/UIKit.h>
#import "RESTApiClient.h"

@import AudioToolbox;

@interface HandleBeacon ()

@property (nonatomic) CLBeaconRegion *myBeaconRegion;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property CLProximity lastProximity;
@property (nonatomic) Device *device;
@property (nonatomic, assign) bool notificationToReturnDeviceWasSend;
@property (nonatomic, assign) bool notificationToBookDeviceWasSend;
@property (nonatomic) UserDefaultsWrapper *userDefaultsWrapper;

@end

@implementation HandleBeacon

- (instancetype)initWithUserDefaultsWrapper:(UserDefaultsWrapper *)userDefaultsWrapper {
    NSParameterAssert(userDefaultsWrapper);

    self = [super init];
    if (self) {
        _userDefaultsWrapper = userDefaultsWrapper;
    }
    return self;
}

- (void)searchForBeacon {
    if ([self.userDefaultsWrapper isLocalDevice]) {
        
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
        
        self.device = [self.userDefaultsWrapper getLocalDevice];
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
    
    self.device = [self.userDefaultsWrapper getLocalDevice];
    NSLog(@"booked %@", self.device.isBookedByPerson ? @"YES" : @"NO");
    NSLog(@"notif. return %@", self.notificationToReturnDeviceWasSend ? @"YES" : @"NO");
    if (self.device.isBookedByPerson && !self.notificationToReturnDeviceWasSend) {
        [self sendLocalNotificationWithMessage:NSLocalizedString(@"NOTIFICATION_RETURN_LABEL", nil)];
        self.notificationToReturnDeviceWasSend = YES;
        self.notificationToBookDeviceWasSend = NO;
        NSLog(@"Return notification was send from didEnter");
    }

    [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager*)manager didExitRegion:(CLBeaconRegion*)region {
    NSLog(@"Device did Exit Region");
    NSLog(@"booked %@", self.device.isBookedByPerson ? @"YES" : @"NO");
    NSLog(@"notif. book %@", self.notificationToBookDeviceWasSend ? @"YES" : @"NO");
    
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    self.device = [self.userDefaultsWrapper getLocalDevice];
    if (!self.device.isBookedByPerson) {
        [self sendLocalNotificationWithMessage:NSLocalizedString(@"NOTIFICATION_BOOK_LABEL", nil)];
        self.notificationToBookDeviceWasSend = YES;
        self.notificationToReturnDeviceWasSend = NO;
        NSLog(@"Book notification was send from didExit");
    }

    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region {
    
    self.device = [self.userDefaultsWrapper getLocalDevice];
    
    if(beacons.count > 0) {
        NSLog(@"booked %@", self.device.isBookedByPerson ? @"YES" : @"NO");
        NSLog(@"notif. return %@", self.notificationToReturnDeviceWasSend ? @"YES" : @"NO");
        if (self.device.isBookedByPerson && !self.notificationToReturnDeviceWasSend) {
            [self sendLocalNotificationWithMessage:NSLocalizedString(@"NOTIFICATION_RETURN_LABEL", nil)];
            self.notificationToReturnDeviceWasSend = YES;
            self.notificationToBookDeviceWasSend = NO;
            NSLog(@"Return notification was send from beacons found");
        }
    } else {
        NSLog(@"booked %@", self.device.isBookedByPerson ? @"YES" : @"NO");
        NSLog(@"notif. book %@", self.notificationToBookDeviceWasSend ? @"YES" : @"NO");
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

- (void)didReceiveLocalNotification:(UILocalNotification *)notification {
    //http://stackoverflow.com/questions/15287678/warning-attempt-to-present-viewcontroller-whose-view-is-not-in-the-window-hiera

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    UINavigationController *navigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"OverviewNavigationController"];
    OverviewViewController *overviewController = (OverviewViewController *)navigationController.topViewController;
    
    window.rootViewController = navigationController;
    [window makeKeyAndVisible];
    
    overviewController.forwardToDevice = [Injector.sharedInstance.userDefaultsWrapper getLocalDevice];
    if ([notification.alertBody isEqualToString:NSLocalizedString(@"NOTIFICATION_RETURN_LABEL", nil)]) {
        overviewController.automaticReturn = YES;
    }
    [overviewController performSegueWithIdentifier:@"FromOverviewToDeviceView" sender:nil];
}

@end
