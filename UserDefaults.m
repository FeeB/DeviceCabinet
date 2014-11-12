//
//  UserDefaults.m
//  Device Cabinet
//
//  Created by Braun,Fee on 14.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "UserDefaults.h"
#import "UIdGenerator.h"
#import "Device.h"

NSString * const KeyForDevice = @"currentDevice";
NSString * const KeyForBooleanFirstLaunch = @"isFirstLaunch";
NSString * const KeyForFirstLaunch = @"firstLaunch";

@interface UserDefaults ()

@end

@implementation UserDefaults

- (BOOL)firstLaunch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:KeyForFirstLaunch] == nil) {
        self.isFirstLaunch = NO;
        [userDefaults setObject:@"value" forKey:KeyForFirstLaunch];
        [userDefaults setBool:self.isFirstLaunch forKey:KeyForFirstLaunch];
        return YES;
    } else if (self.isFirstLaunch) {
        self.isFirstLaunch = NO;
        [userDefaults setBool:self.isFirstLaunch forKey:KeyForFirstLaunch];
        return YES;
    }
    return NO;
}

- (Device *)getDevice {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [userDefaults objectForKey:KeyForDevice];
    return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
}

- (void)storeDeviceWithDevice:(Device *)device {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:device];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.isFirstLaunch = NO;
    [userDefaults setBool:self.isFirstLaunch forKey:KeyForFirstLaunch];
    [userDefaults setObject:encodedObject forKey:KeyForDevice];
}

- (void)resetUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:KeyForDevice];
}

@end
