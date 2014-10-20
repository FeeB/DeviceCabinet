//
//  UserDefaults.m
//  Device Cabinet
//
//  Created by Braun,Fee on 14.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "UserDefaults.h"
#import "UIdGenerator.h"

NSString * const KeyForUserDefaults = @"identifier";
NSString * const KeyForUserType = @"type";

@interface UserDefaults ()

@end

@implementation UserDefaults

- (NSString *)getUserIdentifier {
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *identifier = [self.userDefaults objectForKey:KeyForUserDefaults];
    
    if (identifier) {
        return identifier;
    } else {
        UIdGenerator *uidGenerator = [[UIdGenerator alloc]init];
        if ([uidGenerator hasDeviceIdInKeyChain]) {
            NSString *newIdentifier = [uidGenerator getIdfromKeychain];
            [self storeUserDefaults:newIdentifier userType:@"device"];
            return newIdentifier;
        } else {
            return nil;
        }
    }
}

- (NSString *)getUserType {
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userType = [self.userDefaults objectForKey:KeyForUserType];
    
    if (userType) {
        return userType;
    } else {
        UIdGenerator *uidGenerator = [[UIdGenerator alloc]init];
        if ([uidGenerator hasDeviceIdInKeyChain]) {
            NSString *newIdentifier = [uidGenerator getIdfromKeychain];
            NSString *newUserType = @"device";
            [self storeUserDefaults:newIdentifier userType:newUserType];
            return newUserType;
        } else {
            return nil;
        }
    }
}

- (void)storeUserDefaults:(NSString *)uniqueIdentifier userType:(NSString *)userType {
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [self.userDefaults setObject:uniqueIdentifier forKey:KeyForUserDefaults];
    [self.userDefaults setObject:userType forKey:KeyForUserType];
    [self.userDefaults synchronize];
}

- (void)resetUserDefaults {
    NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
}
@end
