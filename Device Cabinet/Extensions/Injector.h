//
//  Injetor.h
//  Device Cabinet
//
//  Created by Fee Kristin Braun on 30.11.14.
//  Copyright (c) 2014 Fee Kristin Braun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RailsApiDao;
@class UserDefaultsWrapper;
@class HandleBeacon;

@interface Injector : NSObject

@property UserDefaultsWrapper *userDefaultsWrapper;
@property RailsApiDao *railsApiDao;
@property HandleBeacon *handleBeacon;

+ (instancetype)sharedInstance;

@end
