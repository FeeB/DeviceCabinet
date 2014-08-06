//
//  DeviceViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *deviceLabel;
@property (nonatomic, weak) IBOutlet NSString *deviceName;

@property (nonatomic, weak) IBOutlet UILabel *deviceCategoryLabel;
@property (nonatomic, weak) IBOutlet NSString *deviceCategory;

@property (nonatomic, weak) IBOutlet UILabel *bookedFromLabel;
@property (nonatomic, weak) IBOutlet NSString *bookedFrom;


@end
