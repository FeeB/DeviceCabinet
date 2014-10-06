//
//  BeaconNotificationRegion.h
//  BeaconDemo
//
//  Created by Trent Shumay on 3/3/2014.
//  Copyright (c) 2014 IoT Design Shop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// BeaconNotificationRegions are simple container objects which wrap up the details
// required to manage beacon regions and corresponding notifications in our system.
// They contain the specific identification information for a beacon region as well
// as the messages that we would like to send to the user when they enter and exit
// the specified region.

@interface BeaconNotificationRegion : NSObject

@property (strong, nonatomic) NSString* beaconUUID;         // UUID for beacon in this event
@property (strong, nonatomic) NSNumber* beaconMajor;        // Major ID of beacon in this event (optional)
@property (strong, nonatomic) NSNumber* beaconMinor;        // Minor ID of beacon in this event (optional)

@property (strong, nonatomic) NSString* helloMessage;       // Message to display when user enters the beacon region
@property (strong, nonatomic) NSString* goodbyeMessage;     // Message to display when user exits the beacon region

@property (assign, nonatomic) CLRegionState lastState;      // State of beacon as of last update

@property (assign, nonatomic) CLProximity lastProximity;            // Proximity of beacon as of last update
@property (assign, nonatomic) CLLocationAccuracy lastAccuracy;      // Accuracy of beacon as of last update
@property (assign, nonatomic) NSInteger lastRSSI;                   // Signal strength of beacon as of last update
@end
