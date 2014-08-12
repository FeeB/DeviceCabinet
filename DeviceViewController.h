//
//  DeviceViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>
#import "Device.h"
#import "Person.h"

@interface DeviceViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *deviceLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceCategoryLabel;

@property (nonatomic, weak) IBOutlet UILabel *bookedFromLabel;
@property (nonatomic, weak) NSString *bookedFrom;

@property (nonatomic, strong) Device *deviceObject;
@property (nonatomic, strong) Person *personObject;

-(IBAction)bookDevice;
-(void)storeReference;


@end
