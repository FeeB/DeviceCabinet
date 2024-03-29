//
//  OverviewViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 04.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Device;
@interface OverviewViewController : UITableViewController <NSURLConnectionDataDelegate>

@property (nonatomic, strong) Device *device;
@property (nonatomic, strong) Device *forwardToDevice;
@property (nonatomic, assign) BOOL automaticReturn;

- (void)getAllDevices;

@end
