//
//  OverviewViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 04.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudKitDao.h"

@interface OverviewViewController : UITableViewController <NSURLConnectionDataDelegate>

@property (nonatomic, assign) BOOL forwardToDeviceView;
@property (nonatomic, strong) Device *device;
@property (nonatomic, strong) Device *forwardedDevice;
@property (nonatomic, weak) IBOutlet UIImageView *userPhoto;


- (void)getAllDevices;

@end
