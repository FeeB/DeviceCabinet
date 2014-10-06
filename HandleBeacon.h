//
//  HandleBeacon.h
//  Device Cabinet
//
//  Created by Braun,Fee on 06.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeaconNotificationRegion.h"

@interface HandleBeacon : NSObject

@property (strong, nonatomic) BeaconNotificationRegion *detailItem;

-(void)registerNotification;

@end
