//
//  Injetor.m
//  Device Cabinet
//
//  Created by Fee Kristin Braun on 30.11.14.
//  Copyright (c) 2014 Fee Kristin Braun. All rights reserved.
//

#import "Injector.h"

#import "RailsApiDao.h"
#import "AFNetworking.h"
#import "UserDefaultsWrapper.h"
#import "HandleBeacon.h"
#import "KeyChainItemWrapper.h"
#import "KeyChainWrapper.h"
#import "LaunchHandler.h"

@implementation Injector

+ (instancetype)sharedInstance {
    static Injector *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Injector alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _railsApiDao = [[RailsApiDao alloc] initWithRequestOperationManager:[AFHTTPRequestOperationManager manager]];
        _userDefaultsWrapper = [[UserDefaultsWrapper alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
        _handleBeacon = [[HandleBeacon alloc] initWithUserDefaultsWrapper:self.userDefaultsWrapper];
        _keyChainWrapper = [[KeyChainWrapper alloc] initWithKeyChainWrapperItem:[[KeychainItemWrapper alloc] initWithIdentifier:@"deviceId" accessGroup:nil]];
        _launchHandler = [[LaunchHandler alloc] initWithUserDefaults:self.userDefaultsWrapper keyChainWrapper:self.keyChainWrapper railsApiDao:self.railsApiDao];
    }
    return self;
}

@end
