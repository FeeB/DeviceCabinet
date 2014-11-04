//
//  HandleBeacon.h
//  Device Cabinet
//
//  Created by Braun,Fee on 06.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeaconNotificationRegion.h"
#import <CoreLocation/CoreLocation.h>
#import "Device.h"
#import "UserDefaults.h"

@interface HandleBeacon : NSObject <CLLocationManagerDelegate>

@property (nonatomic) CLBeaconRegion *myBeaconRegion;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property CLProximity lastProximity;
@property CLProximity beforeLastProximity;
@property (nonatomic) NSString *userIdentifier;
@property (nonatomic) NSString *userType;
@property (nonatomic) Device *deviceObject;

- (void)searchForBeacon;

@end
