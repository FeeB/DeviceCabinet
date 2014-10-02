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

@property (nonatomic, strong) IBOutlet UINavigationItem *profileItem;
@property (nonatomic, strong) IBOutlet UILabel *cellLabelType;
@property (nonatomic, assign) BOOL userIsLoggedIn;
@property (nonatomic, assign) BOOL forwardToDeviceView;

- (void)getAllDevices;

@end
