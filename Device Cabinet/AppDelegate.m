
//
//  AppDelegate.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "RailsApiDao.h"
#import "HandleBeacon.h"
#import "OverviewViewController.h"
#import "UserDefaultsWrapper.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    self.handleBeacon = [[HandleBeacon alloc] init];
    [self.handleBeacon searchForBeacon];
    
    //register Notification for ios8 and ask for permission
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    //Write NSLog in a File
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"%@.log",[NSDate date]];
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    if (application.applicationState != UIApplicationStateActive) {
        
        //http://stackoverflow.com/questions/15287678/warning-attempt-to-present-viewcontroller-whose-view-is-not-in-the-window-hiera
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        UINavigationController *navigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"OverviewNavigationController"];
        OverviewViewController *overviewController = (OverviewViewController *)navigationController.topViewController;
        
        self.window.rootViewController = navigationController;
        [self.window makeKeyAndVisible];
        
        overviewController.forwardToDevice = [UserDefaultsWrapper getLocalDevice];
        if ([notification.alertBody isEqualToString:NSLocalizedString(@"NOTIFICATION_RETURN_LABEL", nil)]) {
            overviewController.automaticReturn = YES;
        }
        [overviewController performSegueWithIdentifier:@"FromOverviewToDeviceView" sender:nil];
    } 
}

@end
