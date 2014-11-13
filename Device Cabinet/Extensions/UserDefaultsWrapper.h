//
//  UserDefaults.h
//  Device Cabinet
//
//  Created by Braun,Fee on 14.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

@class Device;

@interface UserDefaultsWrapper : NSObject

- (BOOL)isFirstLaunch;
- (Device *)getDevice;
- (void)setDevice:(Device *)device;

- (void)resetUserDefaults;

@end
