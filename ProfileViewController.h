//
//  ProfileViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "Device.h"

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UITableView *customTableView;
@property (nonatomic, weak) IBOutlet UILabel *bookedDevicesLabel;
@property (nonatomic, weak) Person *personObject;
@property (nonatomic, weak) Device *deviceObject;

- (void)getAllBookedDevices;
- (IBAction)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (IBAction)logOut;

@end
