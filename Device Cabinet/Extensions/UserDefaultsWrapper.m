//
//  UserDefaults.m
//  Device Cabinet
//
//  Created by Braun,Fee on 14.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "UserDefaultsWrapper.h"
#import "KeyChainWrapper.h"
#import "Device.h"
#import "AppDelegate.h"
#import "RailsApiErrorMapper.h"

NSString * const KeyForDevice = @"currentDevice";
NSString * const KeyForBooleanFirstLaunch = @"isFirstLaunch";
NSString * const KeyForFirstLaunch = @"firstLaunch";

@implementation UserDefaultsWrapper

+ (BOOL)isFirstLaunch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:KeyForFirstLaunch] == nil) {
        [userDefaults setObject:@"value" forKey:KeyForFirstLaunch];
        [userDefaults setBool:NO forKey:KeyForFirstLaunch];
        return YES;
    }
    return NO;
}

+ (Device *)getDevice {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [userDefaults valueForKey:KeyForDevice];
    if (encodedObject) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    return nil;
}

+ (void)setDevice:(Device *)device {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:device];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:encodedObject forKey:KeyForDevice];
}

+ (void)reset {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:KeyForDevice];
}

@end
