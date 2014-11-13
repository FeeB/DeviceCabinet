//
//  UIdGenerator.m
//  Device Cabinet
//
//  Created by Braun,Fee on 18.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "KeyChainWrapper.h"
#import "KeychainItemWrapper.h"
#import "UdIdGenerator.h"

NSString * const KeyForKeychain = @"deviceId";

@implementation KeyChainWrapper

- (void)setDeviceUdId:(NSString *)deviceId {
    KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"deviceId" accessGroup:nil];
    [keychain setObject:@"Myappstring" forKey: (__bridge id)kSecAttrService];
    [keychain setObject:deviceId forKey:(__bridge id)(kSecAttrAccount)];
}

- (NSString *)getDeviceUdId {
    KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"deviceId" accessGroup:nil];
    NSString *object = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    return object;
}

- (void)resetKeyChain {
    KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"deviceId" accessGroup:nil];
    [keychain resetKeychainItem];
}

- (BOOL)hasDeviceUdId {
    if ([[self getDeviceUdId] isEqualToString:@""]) {
        return NO;
    } else {
        return YES;
    }
}

@end
