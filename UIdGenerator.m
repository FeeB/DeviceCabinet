//
//  UIdGenerator.m
//  Device Cabinet
//
//  Created by Braun,Fee on 18.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "UIdGenerator.h"
#import "KeychainItemWrapper.h"
#import "UserDefaults.h"

NSString * const KeyForKeychain = @"deviceId";

@implementation UIdGenerator

- (NSString *)getDeviceId {
    NSString *udidString = [self getIdfromKeychain];
    if([udidString isEqualToString:@""])
    {
        CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
        udidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
        CFRelease(cfuuid);
        UserDefaults *userDefaults = [[UserDefaults alloc]init];
        [userDefaults storeUserDefaults:udidString userType:@"device"];
        [self setDeviceId:udidString];
    }
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    [userDefaults storeUserDefaults:udidString userType:@"device"];
    return udidString;
}

- (void) setDeviceId:(NSString *)deviceId {
    KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"deviceId" accessGroup:nil];
    [keychain setObject:@"Myappstring" forKey: (__bridge id)kSecAttrService];
    [keychain setObject:deviceId forKey:(__bridge id)(kSecAttrAccount)];
}

- (NSString *) getIdfromKeychain {
    KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"deviceId" accessGroup:nil];
    NSString *object = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    return object;
}

- (void) resetKeyChain {
    KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"deviceId" accessGroup:nil];
    [keychain resetKeychainItem];
}

@end
