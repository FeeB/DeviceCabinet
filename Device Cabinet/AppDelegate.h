//
//  AppDelegate.h
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceCabinetDAO.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property NSObject<DeviceCabinetDao> *dao;
@property (nonatomic) CLBeaconRegion *myBeaconRegion;
@property (nonatomic) CLLocationManager *locationManager;
@property CLProximity lastProximity;

+ (NSObject<DeviceCabinetDao> *)dao;

@end
