//
//  ProfileViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "ProfileViewController.h"
#import "Person.h"
#import "Device.h"
#import "DeviceViewController.h"
#import "UserDefaults.h"
#import "TEDLocalization.h"
#import "AppDelegate.h"

NSString * const FromProfileToDeviceSegue = @"FromProfileToDeviceOverview";

@interface ProfileViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation ProfileViewController

NSString * const LogoutButtonSegue = @"FromLogOutButtonToLogIn";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bookedDevicesLabel.text = NSLocalizedString(@"SECTION_BOOKED_DEVICES", nil);
    
    [TEDLocalization localize:self];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.transform = CGAffineTransformMakeScale(2, 2);
    self.spinner.center = self.customTableView.center;
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAllBookedDevices];
}

//standard methods for tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)getAllBookedDevices {
    [self.spinner startAnimating];
    UserDefaults *userDefaults = [[UserDefaults alloc]init];

    [AppDelegate.dao fetchPersonWithUsername:[userDefaults getUserIdentifier] completionHandler:^(Person *person, NSError *error) {
        if (error) {
            [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                       message:error.localizedRecoverySuggestion
                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            self.personObject = person;
            self.nameLabel.text = self.personObject.fullName;
            
            [AppDelegate.dao fetchDevicesWithPerson:self.personObject completionHandler:^(NSArray *devicesArray, NSError *error) {
                if (error) {
                    [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                               message:error.localizedRecoverySuggestion
                                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                } else {
                    self.list = [[NSMutableArray alloc] init];
                    for (Device *device in devicesArray){
                        [self.list addObject:device];
                    }
                    [self.customTableView reloadData];
                    [self.spinner stopAnimating];
                }
            }];
        }
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
        controller.onCompletion = ^(BOOL isLoggedIn) {
            self.userIsLoggedIn = NO;
            if (self.onCompletion) {
                self.onCompletion(self.userIsLoggedIn);
            }
            [self.navigationController popViewControllerAnimated:YES];
        };
    }
}

- (IBAction)logOut {
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
//    [userDefaults resetUserDefaults];
    
    self.userIsLoggedIn = NO;
    if (self.onCompletion) {
        self.onCompletion(self.userIsLoggedIn);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
