//
//  UserDefaults.h
//  Device Cabinet
//
//  Created by Braun,Fee on 14.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "Device.h"

@interface UserDefaults : NSObject

@property (nonatomic, assign) BOOL isFirstLaunch;

- (BOOL)firstLaunch;
- (Device *)getDevice;
- (void)storeDeviceWithDevice:(Device *)device;
- (void)resetUserDefaults;


@end
