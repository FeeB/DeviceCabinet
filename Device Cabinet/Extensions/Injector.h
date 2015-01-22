//
//  Injetor.h
//  Device Cabinet
//
//  Created by Fee Kristin Braun on 30.11.14.
//  Copyright (c) 2014 Fee Kristin Braun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RESTApiClient;
@class UserDefaultsWrapper;
@class HandleBeacon;
@class KeyChainWrapper;
@class LaunchHandler;

@interface Injector : NSObject

@property UserDefaultsWrapper *userDefaultsWrapper;
@property RESTApiClient *railsApiDao;
@property HandleBeacon *handleBeacon;
@property KeyChainWrapper *keyChainWrapper;
@property LaunchHandler *launchHandler;

+ (instancetype)sharedInstance;

@end
