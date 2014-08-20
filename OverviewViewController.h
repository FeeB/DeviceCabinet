//
//  OverviewViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 04.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudKitManager.h"

@interface OverviewViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UINavigationItem *profileItem;
@property (nonatomic, assign) BOOL comesFromRegister;

extern NSString const *FromOverViewToDeviceViewSegue;


- (void)getAllDevices;
- (IBAction)logOut;
- (void)checkCurrentUserIsLoggedIn;

@end
