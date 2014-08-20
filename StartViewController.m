//
//  StartViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 20.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "StartViewController.h"
#import "ProfileViewController.h"
#import "UserDefaults.h"
#import "CloudKitManager.h"
#import "Device.h"
#import "DeviceViewController.h"

NSString * const FromeStartToOverviewSegue = @"FromStartToOverview";
NSString * const FromStartToLogInSegue = @"FromStartToLogIn";
NSString * const FromStartToDeviceOverviewSegue = @"FromStartToDeviceOverview";

@interface StartViewController ()
@property (nonatomic, strong) Device *device;
@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkCurrentUserIsLoggedIn];
}

- (void)checkCurrentUserIsLoggedIn {
    if ([self currentUserHasStoredIdentifier]) {
        
        NSString *currentUserIdentifier = [self currentUserHasStoredIdentifier];
        
        if ([self userIsPerson]) {
            [self handlePersonUserWithIdentifier:currentUserIdentifier];
        } else {
            [self handleDeviceUserWithIdentifier:currentUserIdentifier];        }
        
    } else {
        [self performSegueWithIdentifier:FromStartToLogInSegue sender:self];
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

- (void)handlePersonUserWithIdentifier:(NSString *)currentUserIdentifier {
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    [cloudManager fetchPersonWithUsername:currentUserIdentifier completionHandler:^(Person *person) {
        
        if (person) {
            [self performSegueWithIdentifier:FromeStartToOverviewSegue sender:self];
        } else {
            [self performSegueWithIdentifier:FromStartToLogInSegue sender:self];
        }
    }];
}

- (void)handleDeviceUserWithIdentifier:(NSString *)currentUserIdentifier {
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    [cloudManager fetchDeviceWithDeviceId:currentUserIdentifier completionHandler:^(Device *device) {
        
        if (device) {
            self.device = device;
            [self performSegueWithIdentifier:FromStartToDeviceOverviewSegue sender:nil];
        } else {
            [self performSegueWithIdentifier:FromStartToLogInSegue sender:self];
            
        }
    }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FromStartToDeviceOverviewSegue]) {
        DeviceViewController *controller = (DeviceViewController *)segue.destinationViewController;
        controller.deviceObject = self.device;
    }
}

@end
