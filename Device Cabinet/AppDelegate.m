
//
//  AppDelegate.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "AppDelegate.h"
#import "RESTApiClient.h"
#import "HandleBeacon.h"
#import "OverviewViewController.h"
#import "UserDefaultsWrapper.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[Injector sharedInstance].handleBeacon searchForBeacon];
    
    //register Notification for ios8 and ask for permission
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    //Write NSLog in a File
    //http://azizuysal.com/2011/01/02/redirecting-nslog-output-to-a-file-on-demand-for-iphone-debugging/
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
        [Injector.sharedInstance.handleBeacon didReceiveLocalNotification:notification];
    }
}

@end
