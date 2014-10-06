//
//  BeaconDemoAppDelegate.h
//  BeaconDemo
//
//  Created by Trent Shumay on 3/3/2014.
//  Copyright (c) 2014 IoT Design Shop. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@class BeaconNotificationRegion;

@interface BeaconDemoAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

// -- Notification region management --

// Because the manipulation of notification regions has a requirement for the changes to be registered and
// unregistered with the location system, we provide an interface that wraps up the basic NSMutableArray-style
// interactions with our list of notification regions so that we can add the additional logic into the flow
// where it is needed on behalf of the App.

// Register a new notification region with the system
-(void)addNotificationRegion:(BeaconNotificationRegion*)newRegion;

// Retrieve a notification region by index
-(BeaconNotificationRegion*)notificationRegionAtIndex:(NSUInteger)index;

// Retrieve the total count of registered regions
-(NSInteger)notificationRegionCount;

// Remove a notification region
-(void)removeNotificationRegion:(BeaconNotificationRegion*)region;

// Remove a notification region by index
-(void)removeNotificationRegionAtIndex:(NSUInteger)index;


// -- Persistence --

// These methods are used to save and load notification regions from disk so that the App can keep
// track of the user's notification settings.

// Save all notification regions
-(void)saveNotificationRegions;

// Load notification regions
-(void)loadNotificationRegions;

@end
