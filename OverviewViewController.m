//
//  OverviewViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 04.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "OverviewViewController.h"
#import "CloudKitManager.h"
#import "DeviceViewController.h"
#import "LogInViewController.h"
#import "UserDefaults.h"
#import "UIdGenerator.h"

NSString * const DeviceControllerIdentifier = @"DeviceControllerID";
NSString * const LogInSegueIdentifier = @"logIn";

@interface OverviewViewController ()

@property (nonatomic, strong) NSMutableArray *lists;

@end

@implementation OverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.comesFromRegister) {
        [self checkCurrentUserIsLoggedIn];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAllDevices];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.lists.count;
}

//standard methods for tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.lists objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    NSArray *array = [self.lists objectAtIndex:indexPath.section];
    Device *cellDevice = [array objectAtIndex:indexPath.row];
    NSString *cellValue = cellDevice.deviceName;
    cell.textLabel.text = cellValue;
    
    return cell;
}

//On click on one cell the device view will appear
- (IBAction)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"fromTableToDeviceView" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fromTableToDeviceView"]) {
        DeviceViewController *controller = (DeviceViewController *)segue.destinationViewController;
        NSArray *array = [self.lists objectAtIndex:self.table.indexPathForSelectedRow.section];
        controller.deviceObject = [array objectAtIndex:self.table.indexPathForSelectedRow.row];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.lists.count == 2) {
        return section == 0 ? NSLocalizedString(@"booked-devices", nil) : NSLocalizedString(@"free-devices", nil);
    } else {
        NSArray *devices = self.lists[0];
        if (devices.count > 0 && ((Device *)devices[0]).isBooked) {
            return NSLocalizedString(@"booked-devices", nil);
        } else {
            return NSLocalizedString(@"free-devices", nil);
        }
    }
}

//get all devices for the device overview
- (void)getAllDevices {
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    [cloudManager fetchDevicesWithCompletionHandler:^(NSArray *deviceObjects) {
        self.lists = [[NSMutableArray alloc] init];
        NSMutableArray *bookedDevices = [[NSMutableArray alloc] init];
        NSMutableArray *freeDevices = [[NSMutableArray alloc] init];

        for (Device *device in deviceObjects){
            if (device.isBooked) {
                [bookedDevices addObject:device];
            } else {
                [freeDevices addObject:device];
            }
        }
        
        if (bookedDevices.count > 0) {
            [self.lists addObject:bookedDevices];
        }
        if (freeDevices.count > 0) {
            [self.lists addObject:freeDevices];
        }

        [self.table reloadData];
    }];

}

- (IBAction)logOut {
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    [userDefaults resetUserDefaults];
    [self performSegueWithIdentifier:LogInSegueIdentifier sender:self];
}

- (void)checkCurrentUserIsLoggedIn {
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    NSString *userType = [userDefaults getUserType];
    NSString *currentUserIdentifier = [userDefaults getUserIdentifier];
    
    if (currentUserIdentifier) {
        if ([userType isEqualToString:@"person"]) {
            
            CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
            [cloudManager fetchPersonWithUsername:currentUserIdentifier completionHandler:^(Person *person) {
                if (!person) {
                    [self performSegueWithIdentifier:LogInSegueIdentifier sender:self];
                }
            }];
        } else {
            CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
            [cloudManager fetchDeviceWithDeviceId:currentUserIdentifier completionHandler:^(Device *device) {
                if (device) {
                    DeviceViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceControllerID"];
                    controller.deviceObject = device;
                    [self.navigationController pushViewController:controller animated:YES];
                    [self.navigationController setNavigationBarHidden:YES];
                } else {
                    UIdGenerator *uIdGenerator = [[UIdGenerator alloc]init];
                    [uIdGenerator resetKeyChain];
                    [self performSegueWithIdentifier:LogInSegueIdentifier sender:self];
                    
                }
            }];
        }
    } else {
        UIdGenerator *uIdGenerator = [[UIdGenerator alloc]init];
        [uIdGenerator resetKeyChain];
        [self performSegueWithIdentifier:LogInSegueIdentifier sender:self];
    }
}

@end
