//
//  UserDefaults.h
//  Device Cabinet
//
//  Created by Braun,Fee on 14.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

@interface UserDefaults : NSObject

@property (nonatomic, weak) NSUserDefaults *userDefaults;

- (NSString *)getUserIdentifier;
- (NSString *)getUserType;
- (NSString *)currentPerson;
- (void)storeUserDefaults:(NSString *)uniqueIdentifier userType:(NSString *)userType;
- (void)resetUserDefaults;
- (void)storeCurrentUserWithIdentifier:(NSString *)identifier;
- (NSString *)getCurrentUser;

@end
