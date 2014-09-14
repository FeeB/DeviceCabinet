//
//  AppDelegate.h
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceCabinetDAO.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property NSObject<DeviceCabinetDao> *dao;

+ (NSObject<DeviceCabinetDao> *)dao;

@end
