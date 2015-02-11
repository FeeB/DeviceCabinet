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

@interface KeyChainWrapper ()

@property KeychainItemWrapper *keyChainItemWrapper;

@end

@implementation KeyChainWrapper

- (instancetype)initWithKeyChainWrapperItem: (KeychainItemWrapper *)keyChainItemWrapper {
    self = [super init];
    if (self) {
        _keyChainItemWrapper = keyChainItemWrapper;
    }
    return self;
}

- (void)setDeviceUdId:(NSString *)deviceId {
    [self.keyChainItemWrapper setObject:@"Myappstring" forKey: (__bridge id)kSecAttrService];
    [self.keyChainItemWrapper setObject:deviceId forKey:(__bridge id)(kSecAttrAccount)];
}

- (NSString *)getDeviceUdId {
    NSString *object = [self.keyChainItemWrapper objectForKey:(__bridge id)(kSecAttrAccount)];
    return object;
}

- (void)reset {
    [self.keyChainItemWrapper resetKeychainItem];
}

- (BOOL)hasDeviceUdId {
    if ([[self getDeviceUdId] isEqualToString:@""]) {
        return NO;
    } else {
        return YES;
    }
}

@end
