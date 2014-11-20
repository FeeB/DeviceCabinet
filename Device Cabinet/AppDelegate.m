
//
//  AppDelegate.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "CloudKitDao.h"
#import "RailsApiDao.h"
#import "HandleBeacon.h"
#import "OverviewViewController.h"
#import "UserDefaultsWrapper.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.dao = [[RailsApiDao alloc] init];
    
    self.handleBeacon = [[HandleBeacon alloc] init];
    [self.handleBeacon searchForBeacon];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
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
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        UINavigationController *navigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"OverviewNavigationController"];
        OverviewViewController *overviewController = (OverviewViewController *)navigationController.topViewController;
        
        self.window.rootViewController = navigationController;
        [self.window makeKeyAndVisible];
        
//        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:navigationController animated:NO completion:nil];
        overviewController.forwardToDevice = [UserDefaultsWrapper getLocalDevice];
        if ([notification.alertBody isEqualToString:NSLocalizedString(@"NOTIFICATION_RETURN_LABEL", nil)]) {
            overviewController.automaticReturn = YES;
        }
        [overviewController performSegueWithIdentifier:@"FromOverviewToDeviceView" sender:nil];
    } 
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (NSObject<DeviceCabinetDao> *)dao
{
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).dao;
}

@end
