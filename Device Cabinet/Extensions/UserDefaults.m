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
#import "AppDelegate.h"
#import "RailsApiErrorMapper.h"

NSString * const KeyForDevice = @"currentDevice";
NSString * const KeyForBooleanFirstLaunch = @"isFirstLaunch";
NSString * const KeyForFirstLaunch = @"firstLaunch";

@interface UserDefaults ()

@end

@implementation UserDefaults

- (void)getRightBooleanValueForLaunch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    __block BOOL isFirstLaunch;
    if ([userDefaults objectForKey:KeyForFirstLaunch] == nil) {
        [userDefaults setObject:@"value" forKey:KeyForFirstLaunch];
        [userDefaults setBool:isFirstLaunch forKey:KeyForFirstLaunch];
        isFirstLaunch = YES;
    } else if (self.isFirstLaunch) {
        [userDefaults setBool:isFirstLaunch forKey:KeyForFirstLaunch];
        isFirstLaunch = YES;
    }
    
    if (isFirstLaunch) {
        [self storeDeviceFromKeychainWithCompletionHandler:^(BOOL returnValue) {
            self.isFirstLaunch = returnValue;
        }];
    } else {
        self.isFirstLaunch = NO;
        [userDefaults setBool:self.isFirstLaunch forKey:KeyForFirstLaunch];
    }
}



- (BOOL)firstLaunch {
    if (self.isFirstLaunch) {
        self.isFirstLaunch = NO;
        return YES;
    } else {
        return NO;
    }
}

- (Device *)getDevice {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [userDefaults valueForKey:KeyForDevice];
    if (encodedObject) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    return nil;
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
    UIdGenerator *generator = [[UIdGenerator alloc]init];
    [generator resetKeyChain];
}

@end
