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
- (NSString *)getCurrentUsername;
- (void)storeCurrentUser:(NSString *)username;
- (void)resetCurrentUser;

@end
