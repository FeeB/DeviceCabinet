//
//  ProfileViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "ProfileViewController.h"
#import "CloudKitManager.h"
#import "Person.h"
#import "Device.h"
#import "DeviceViewController.h"
#import "UserDefaults.h"
#import "TEDLocalization.h"

@interface ProfileViewController ()

@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation ProfileViewController

NSString *FromProfileToDeviceSegue = @"FromProfileToDeviceOverview";
NSString *LogoutButtonSegue = @"FromLogOutButtonToLogIn";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bookedDevicesLabel.text = NSLocalizedString(@"SECTION_BOOKED_DEVICES", nil);

    [TEDLocalization localize:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAllBookedDevices];
}

//standard methods for tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Device *device = [self.list objectAtIndex:indexPath.row];
    cell.textLabel.text = device.deviceName;
    return cell;
}

//fetch person record to know the record ID to get all devices with a reference to this person object
-(void)getAllBookedDevices{
    
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    
    [cloudManager fetchPersonWithUsername:[userDefaults getUserIdentifier] completionHandler:^(Person *person) {
        self.personObject = person;
        [self.personObject createFullNameWithFirstName];
        self.nameLabel.text = self.personObject.fullName;
    
        [cloudManager fetchDevicesWithPersonID:self.personObject.recordId completionHandler:^(NSArray *devicesArray) {
            self.list = [[NSMutableArray alloc] init];
            for (Device *device in devicesArray){
                [self.list addObject:device];
            }
            [self.customTableView reloadData];
        }];
    }];
}

//On click on one cell the device view will appear
- (IBAction)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:FromProfileToDeviceSegue sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FromProfileToDeviceSegue]) {
        DeviceViewController *controller = (DeviceViewController *)segue.destinationViewController;
        controller.deviceObject = [self.list objectAtIndex:self.customTableView.indexPathForSelectedRow.row];
    }
}

- (IBAction)logOut{
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    [userDefaults resetUserDefaults];
    [self performSegueWithIdentifier:LogoutButtonSegue sender:self];
}

@end
