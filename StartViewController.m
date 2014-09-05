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
#import "Device.h"
#import "DeviceViewController.h"
#import "UIdGenerator.h"
#import "OverviewViewController.h"
#import "AppDelegate.h"

NSString * const FromeStartToOverviewSegue = @"FromStartToOverview";
NSString * const FromStartToLogInSegue = @"FromStartToLogIn";
NSString * const FromStartToDeviceOverviewSegue = @"FromStartToDeviceOverview";

@interface StartViewController ()
@property (nonatomic, strong) Device *device;
@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
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
        self.isUserLoggedIn = NO;
        [self performSegueWithIdentifier:FromeStartToOverviewSegue sender:self];
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
    [AppDelegate.dao fetchPersonWithUsername:currentUserIdentifier completionHandler:^(Person *person, NSError *error) {
        if (error) {
            UserDefaults *userDefaults = [[UserDefaults alloc]init];
            [userDefaults resetUserDefaults];
            
            self.isUserLoggedIn = NO;
            
            [self performSegueWithIdentifier:FromeStartToOverviewSegue sender:self];
        } else {
            self.isUserLoggedIn = YES;
            
            [self performSegueWithIdentifier:FromeStartToOverviewSegue sender:self];
        }
    }];
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
