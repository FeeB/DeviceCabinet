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
    }
    return self;
}

@end
