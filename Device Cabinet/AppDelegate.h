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

@class HandleBeacon;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property NSObject<DeviceCabinetDao> *dao;
@property (nonatomic) HandleBeacon *handleBeacon;

+ (NSObject<DeviceCabinetDao> *)dao;

@end
