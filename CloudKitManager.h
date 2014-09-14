//
//  CloudKitManager.h
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import "Person.h"
#import "Device.h"
#import "DeviceCabinetDAO.h"

@interface CloudKitManager : NSObject <DeviceCabinetDAO>

@end
