//
//  UserDefaults.h
//  Device Cabinet
//
//  Created by Braun,Fee on 14.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

@class Device;

@interface UserDefaultsWrapper : NSObject

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults;
- (BOOL)isFirstLaunch;
- (Device *)getLocalDevice;
- (void)setLocalDevice:(Device *)device;
- (BOOL)isLocalDevice;
- (void)reset;

@end
