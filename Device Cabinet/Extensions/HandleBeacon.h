//
//  HandleBeacon.h
//  Device Cabinet
//
//  Created by Braun,Fee on 06.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HandleBeacon : NSObject <CLLocationManagerDelegate>

- (instancetype)initWithUserDefaultsWrapper:(UserDefaultsWrapper *)userDefaultsWrapper;
- (void)searchForBeacon;
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

@end
