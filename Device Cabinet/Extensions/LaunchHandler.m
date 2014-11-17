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
#import "AppDelegate.h"
#import "RailsApiErrorMapper.h"

@implementation LaunchHandler

+ (void)handleFirstLaunchWithCompletionHandler:(void (^)(BOOL shouldShowDecision))completionHandler {
    
    if ([UserDefaultsWrapper isFirstLaunch]) {
        if ([KeyChainWrapper hasDeviceUdId]) {
            NSString *deviceUdId = [KeyChainWrapper getDeviceUdId];
            [AppDelegate.dao fetchDeviceWithDeviceUdId:deviceUdId completionHandler:^(Device *device, NSError *error) {
                if (device) {
                    [UserDefaultsWrapper setLocalDevice:device];
                    [LaunchHandler shouldShowDecision:NO completionHandler:completionHandler];
                } else {
                    [LaunchHandler shouldShowDecision:YES completionHandler:completionHandler];
                }
            }];
        } else {
            [LaunchHandler shouldShowDecision:YES completionHandler:completionHandler];
        }
    } else {
        [LaunchHandler shouldShowDecision:NO completionHandler:completionHandler];
    }
}

+ (void)shouldShowDecision:(BOOL)runOverview completionHandler:(void (^)(BOOL))completionHandler {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        completionHandler(runOverview);
    });
}

@end
