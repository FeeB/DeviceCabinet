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

@property (nonatomic, strong) Device *device;
@property (nonatomic, strong) Device *forwardToDevice;
@property (nonatomic, weak) IBOutlet UIImageView *userPhoto;
@property (nonatomic, assign) BOOL automaticReturn;

- (void)getAllDevices;

@end
