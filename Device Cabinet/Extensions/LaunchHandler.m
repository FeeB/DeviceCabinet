//
//  FirstLaunchHandler.m
//  Device Cabinet
//
//  Created by Fee Kristin Braun on 13.11.14.
//  Copyright (c) 2014 Fee Kristin Braun. All rights reserved.
//

#import "LaunchHandler.h"
#import "UserDefaultsWrapper.h"
#import "KeyChainWrapper.h"
#import "RailsApiErrorMapper.h"
#import "RailsApiDao.h"

@interface LaunchHandler ()

@property UserDefaultsWrapper *userDefaults;
@property KeyChainWrapper *keyChainWrapper;
@property RailsApiDao *railsApiDao;

@end

@implementation LaunchHandler

- (instancetype)initWithUserDefaults: (UserDefaultsWrapper *)userDefaults keyChainWrapper:(KeyChainWrapper *)keyChainWrapper railsApiDao:(RailsApiDao *)railsApiDao
{
    NSParameterAssert(userDefaults);
    NSParameterAssert(keyChainWrapper);
    NSParameterAssert(railsApiDao);
    
    self = [super init];
    if (self) {
        _userDefaults = userDefaults;
        _keyChainWrapper = keyChainWrapper;
        _railsApiDao = railsApiDao;
    }
    return self;
}

- (void)handleFirstLaunchWithCompletionHandler:(void (^)(BOOL shouldShowDecision))completionHandler {
    
    if ([self.userDefaults isFirstLaunch]) {
        if ([self.keyChainWrapper hasDeviceUdId]) {
            NSString *deviceUdId = [self.keyChainWrapper getDeviceUdId];
            [self.railsApiDao fetchDeviceWithDeviceUdId:deviceUdId completionHandler:^(Device *device, NSError *error) {
                if (device) {
                    [self.userDefaults setLocalDevice:device];
                    [self shouldShowDecision:NO completionHandler:completionHandler];
                } else {
                    [self shouldShowDecision:YES completionHandler:completionHandler];
                }
            }];
        } else {
            [self shouldShowDecision:YES completionHandler:completionHandler];
        }
    } else {
        [self shouldShowDecision:NO completionHandler:completionHandler];
    }
}

- (void)shouldShowDecision:(BOOL)runOverview completionHandler:(void (^)(BOOL))completionHandler {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        completionHandler(runOverview);
    });
}

@end
