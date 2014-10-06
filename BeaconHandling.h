//
//  BeaconHandling.h
//  Device Cabinet
//
//  Created by Braun,Fee on 06.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BEACONinsideSDK/BEACONinsideSDK.h>

@interface BeaconHandling : NSObject

@property (nonatomic, strong) BIBeaconManager *beaconManager;
@property (nonatomic, strong) CLBeaconRegion *monitoredRegion;
@property (nonatomic, strong) CLBeaconRegion *rangedRegion;

//- (BOOL)canStartRegionMonitoring;
//- (BOOL)isMonitoringRegion;
//- (void)startRegionMonitoring;
//- (void)stopRegionMonitoring;
- (void)startRanging;

@end
