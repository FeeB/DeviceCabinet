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
#import "RESTApiErrorMapper.h"

NSString * const KeyForDevice = @"currentDevice";
NSString * const KeyForFirstLaunch = @"firstLaunch";

@interface UserDefaultsWrapper ()

@property NSUserDefaults *userDefaults;

@end

@implementation UserDefaultsWrapper

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults {
    NSParameterAssert(userDefaults);

    self = [super init];
    if (self) {
        _userDefaults = userDefaults;
    }
    return self;
}

- (BOOL)isFirstLaunch {
    if ([self.userDefaults objectForKey:KeyForFirstLaunch] == nil) {
        [self.userDefaults setObject:@"value" forKey:KeyForFirstLaunch];
        [self.userDefaults setBool:NO forKey:KeyForFirstLaunch];
        return YES;
    }
    return NO;
}

- (Device *)getLocalDevice {
    NSData *encodedObject = [self.userDefaults valueForKey:KeyForDevice];
    if (encodedObject) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    return nil;
}

- (void)setLocalDevice:(Device *)device {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:device];
    [self.userDefaults setObject:encodedObject forKey:KeyForDevice];
}

- (BOOL)isLocalDevice {
    return [self getLocalDevice] ? YES : NO;
}

- (void)reset {
    [self.userDefaults removeObjectForKey:KeyForDevice];
}

@end
