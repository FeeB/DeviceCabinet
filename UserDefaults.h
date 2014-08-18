//
//  UserDefaults.h
//  Device Cabinet
//
//  Created by Braun,Fee on 14.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDefaults : UIViewController

@property (nonatomic, weak) NSUserDefaults *userDefaults;
- (NSString *)getUserIdentifier;
- (NSString *)getUserType;
- (void)storeUserDefaults:(NSString *)uniqueIdentifier userType:(NSString *)userType;
- (void)resetUserDefaults;

@end
