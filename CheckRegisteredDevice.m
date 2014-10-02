//
//  CheckRegisteredDevice.m
//  Device Cabinet
//
//  Created by Braun,Fee on 02.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "CheckRegisteredDevice.h"
#import "UserDefaults.h"

@implementation CheckRegisteredDevice

- (void)checkDeviceIsRegistered {
    if ([self firstLaunch]) {
        //Register Modal
    }
}

- (BOOL)firstLaunch {
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    NSString *userType = [userDefaults getUserType];
    
    if (userType) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)currentUserHasStoredIdentifier {
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    NSString *currentUserIdentifier = [userDefaults getUserIdentifier];
    
    if (currentUserIdentifier) {
        return currentUserIdentifier;
    } else {
        return nil;
    }
}

- (BOOL)userIsPerson {
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    NSString *userType = [userDefaults getUserType];
    
    if ([userType isEqualToString:@"person"]){
        return YES;
    } else {
        return NO;
    }
}


- (void)handleDeviceUserWithIdentifier:(NSString *)currentUserIdentifier {
    [AppDelegate.dao fetchDeviceWithDeviceId:currentUserIdentifier completionHandler:^(Device *device, NSError *error) {
        if (error) {
            UserDefaults *userDefaults = [[UserDefaults alloc]init];
            [userDefaults resetUserDefaults];
            
            UIdGenerator *generator = [[UIdGenerator alloc] init];
            [generator resetKeyChain];
            
            self.isUserLoggedIn = NO;
            
            [self performSegueWithIdentifier:FromeStartToOverviewSegue sender:self];
        } else {
            self.isUserLoggedIn = YES;
            self.device = device;
            
            [self performSegueWithIdentifier:FromStartToDeviceOverviewSegue sender:nil];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FromStartToDeviceOverviewSegue]) {
        DeviceViewController *controller = (DeviceViewController *)segue.destinationViewController;
        controller.deviceObject = self.device;
        controller.comesFromStartView = YES;
    } else if ([segue.identifier isEqualToString:FromeStartToOverviewSegue]) {
        OverviewViewController *overviewController = (OverviewViewController *)segue.destinationViewController;
        overviewController.userIsLoggedIn = self.isUserLoggedIn;
    }
}


@end
