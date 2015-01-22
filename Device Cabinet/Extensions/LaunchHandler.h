//
//  FirstLaunchHandler.h
//  Device Cabinet
//
//  Created by Fee Kristin Braun on 13.11.14.
//  Copyright (c) 2014 Fee Kristin Braun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LaunchHandler : NSObject

- (instancetype)initWithUserDefaults: (UserDefaultsWrapper *)userDefaults keyChainWrapper:(KeyChainWrapper *)keyChainWrapper railsApiDao:(RESTApiClient *)railsApiDao;

- (void)handleFirstLaunchWithCompletionHandler:(void (^)(BOOL shouldShowDecision))completionHandler;

@end
