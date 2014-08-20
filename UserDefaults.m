//
//  UserDefaults.m
//  Device Cabinet
//
//  Created by Braun,Fee on 14.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "UserDefaults.h"

NSString * const KeyForUserDefaults = @"identifier";
NSString * const KeyForUserType = @"type";

@interface UserDefaults ()

@end

@implementation UserDefaults

- (NSString *)getUserIdentifier {
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    return [self.userDefaults objectForKey:KeyForUserDefaults];
}

- (NSString *)getUserType {
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    return [self.userDefaults objectForKey:KeyForUserType];
}

- (void)storeUserDefaults:(NSString *)uniqueIdentifier userType:(NSString *)userType{
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [self.userDefaults setObject:uniqueIdentifier forKey:KeyForUserDefaults];
    [self.userDefaults setObject:userType forKey:KeyForUserType];
    [self.userDefaults synchronize];
}

- (void)resetUserDefaults{
    NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
}

@end
