//
//  DeviceViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"
#import "Person.h"

@interface DeviceViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *deviceLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceCategoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *bookedFromLabel;
@property (nonatomic, weak) IBOutlet UILabel *bookedFromLabelText;
@property (nonatomic, weak) IBOutlet UIButton *bookDevice;

@property (nonatomic, strong) Device *deviceObject;
@property (nonatomic, strong) Person *personObject;

@property (nonatomic, strong) UIActivityIndicatorView *spinner;

-(IBAction)fetchPersonRecordOnClick;
-(void)storeReference;
-(void)deleteReference;


@end
