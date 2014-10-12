//
//  beaconViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 07.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface beaconViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic) CLBeaconRegion *myBeaconRegion;
@property (nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
