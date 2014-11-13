//
//  OverviewViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 04.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "OverviewViewController.h"
#import "DeviceViewController.h"
#import "KeyChainWrapper.h"
#import "TEDLocalization.h"
#import "AppDelegate.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "DecisionViewController.h"
#import "CreateDeviceViewController.h"
#import "RailsApiDao.h"
#import "RailsApiErrorMapper.h"
#import "UIDevice-Hardware.h"
#import "UserDefaultsWrapper.h"

@interface OverviewViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSMutableArray *currentDevice;
@property (nonatomic, strong) NSMutableArray *bookedDevices;
@property (nonatomic, strong) NSMutableArray *availableDevices;

@property (nonatomic, strong) NSArray *currentList;

@property (nonatomic, strong) NSIndexPath *indexPathToBeDeleted;
@end

@implementation OverviewViewController

NSString * const FromOverViewToDeviceViewSegue = @"FromOverviewToDeviceView";
NSString * const FromProfileButtonToProfileSegue = @"FromProfileButtonToProfile";
NSString * const FromOverViewToRegisterSegue = @"FromOverViewToRegister";
NSString * const FromOverViewToCreateDeviceSegue = @"FromOverViewToCreateDevice";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TEDLocalization localize:self];

    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.transform = CGAffineTransformMakeScale(2, 2);
    self.spinner.center = self.tableView.center;
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    
    if (self.segmentedControl.numberOfSegments == 2) {
        [self.segmentedControl setTitle:NSLocalizedString(@"SECTION_FREE_DEVICES", nil) forSegmentAtIndex:0];
        [self.segmentedControl setTitle:NSLocalizedString(@"SECTION_BOOKED_DEVICES", nil) forSegmentAtIndex:1];
    } else {
        [self.segmentedControl setTitle:NSLocalizedString(@"SECTION_ACTUAL_DEVICE", nil) forSegmentAtIndex:0];
        [self.segmentedControl setTitle:NSLocalizedString(@"SECTION_FREE_DEVICES", nil) forSegmentAtIndex:1];
        [self.segmentedControl setTitle:NSLocalizedString(@"SECTION_BOOKED_DEVICES", nil) forSegmentAtIndex:2];
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UserDefaultsWrapper *userDefaults = [[UserDefaultsWrapper alloc] init];
    self.device = [userDefaults getDevice];
    
    [self getAllDevices];
    [self checkForUpdates];
    [self handleIfAppRunsOnTestDevice];
}

- (void)handleIfAppRunsOnTestDevice {
    if (self.device) {
        self.currentDevice = [[NSMutableArray alloc] init];
        [self.currentDevice addObject:self.device];
        if (self.segmentedControl.numberOfSegments == 2) {
            [self.segmentedControl insertSegmentWithTitle:NSLocalizedString(@"SECTION_ACTUAL_DEVICE", nil) atIndex:0 animated:NO];
            self.segmentedControl.selectedSegmentIndex = 0;
            self.currentList = self.currentDevice;
        } else {
            self.currentList = self.currentDevice;
        }
    }
}

- (IBAction)sectionDidChange:(UISegmentedControl *)segmentedControl {
    if (segmentedControl.selectedSegmentIndex == 0 + (self.device ? 1 : 0)) {
        self.currentList = self.availableDevices;
    } else if (segmentedControl.selectedSegmentIndex == 1 + (self.device ? 1 : 0)) {
        self.currentList = self.bookedDevices;
    } else {
        self.currentList = self.currentDevice;
    }
    [self.tableView reloadData];
}

- (void)checkForUpdates {
    if (self.device) {
        [AppDelegate.dao fetchDeviceWithDeviceUdId:self.device.deviceUdId completionHandler:^(Device *device, NSError *error) {
            if (error) {
                if (![RailsApiErrorMapper itemNotFoundInDatabaseError]) {
                    [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                               message:error.localizedRecoverySuggestion
                                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                }
            } else {
                if (![device.systemVersion isEqualToString:[[UIDevice currentDevice] systemVersion]]) {
                    self.device.systemVersion = [[UIDevice currentDevice] systemVersion];
                    [[[UserDefaultsWrapper alloc] init] setDevice:device];
                    RailsApiDao *railsApi = [[RailsApiDao alloc]init];
                    [self updateTable];
                    [railsApi updateSystemVersion:self.device completionHandler:^(NSError *error) {
                        if (error) {
                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                            [self.spinner stopAnimating];
                            
                            [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                                       message:error.localizedRecoverySuggestion
                                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                        }
                    }];
                    [self updateTable];
                }
            }
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//standard methods for tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *cellLabelDeviceType = (UILabel *)[cell viewWithTag:200];
    UILabel *cellLabelBookedByPerson = (UILabel *)[cell viewWithTag:300];
    UIImageView *cellUserPhoto = (UIImageView *) [cell viewWithTag:400];
    
    Device *cellDevice = [self.currentList objectAtIndex:indexPath.row];
    cellLabel.text = cellDevice.deviceName;
    cellLabelDeviceType.text = cellDevice.deviceType;
    if (cellDevice.bookedByPerson) {
//        cellLabelBookedByPerson.text = cellDevice.bookedByPersonFullName;
        cellLabelBookedByPerson.text = @"Test Name";
        cellUserPhoto.hidden = NO;
    } else {
        cellLabelBookedByPerson.text = @"";
        cellUserPhoto.hidden = YES;
    }
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    [imageView setImageWithURL:cellDevice.imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}

//On click on one cell the device view will appear
- (IBAction)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:FromOverViewToDeviceViewSegue sender:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.indexPathToBeDeleted = indexPath;
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_DELETE_DEVICE", nil)
                                   message:NSLocalizedString(@"MESSAGE_DELETE_DEVICE", nil)
                                  delegate:self cancelButtonTitle:NSLocalizedString(@"BUTTON_BACK", nil) otherButtonTitles:@"OK", nil] show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"]) {
        [self deleteRowAtIndexPath];
    }
}

- (void)deleteRowAtIndexPath {
    Device *device = [self.currentList objectAtIndex:self.indexPathToBeDeleted.row];
    RailsApiDao *railsApi = [[RailsApiDao alloc]init];
    [railsApi deleteDevice:device completionHandler:^(NSError *error) {
        if (error) {
            [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                       message:error.localizedRecoverySuggestion
                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        
        if ([device.deviceUdId isEqualToString:self.device.deviceUdId]) {
            UserDefaultsWrapper *userDefaults = [[UserDefaultsWrapper alloc]init];
            [userDefaults resetUserDefaults];
            self.device = nil;
            
            if (self.currentList == self.currentDevice) {
                self.currentList = self.availableDevices;
                [self.segmentedControl updateConstraints];
            }
            [self.segmentedControl removeSegmentAtIndex:0 animated:NO];
        }
        [self updateTable];
    }];
}

//get all devices for the device overview
- (void)getAllDevices {
    [self.spinner startAnimating];

    [AppDelegate.dao fetchDevicesWithCompletionHandler:^(NSArray *deviceObjects, NSError *error) {
        [self.spinner stopAnimating];
        if (error) {
            [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                       message:error.localizedRecoverySuggestion
                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        } else {
            self.bookedDevices = [[NSMutableArray alloc] init];
            self.availableDevices = [[NSMutableArray alloc] init];
            
            for (Device *device in deviceObjects){
                if (device.isBookedByPerson) {
                    [self.bookedDevices addObject:device];
                } else {
                    [self.availableDevices addObject:device];
                }
            }
            
            if (self.segmentedControl.numberOfSegments == 2 && self.segmentedControl.selectedSegmentIndex == 0) {
                self.currentList = self.availableDevices;
            }
            
            [self.tableView reloadData];
        }
    }];
}

- (void)updateTable {
    [self getAllDevices];
    [self.refreshControl endRefreshing];
//    UserDefaults *userDefaults = [[UserDefaults alloc]init];
//    self.device = [userDefaults getDevice];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FromOverViewToDeviceViewSegue]) {
        DeviceViewController *controller = (DeviceViewController *)segue.destinationViewController;
        if (self.forwardToDeviceView) {
            controller.deviceObject = self.forwardedDevice;
            self.forwardToDeviceView = NO;
        } else {
            controller.deviceObject = [self.currentList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        }
//    } else if([segue.identifier isEqualToString:FromOverViewToRegisterSegue]) {
//        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
//        DecisionViewController *controller = (DecisionViewController *)navigationController.topViewController;
//        
//        controller.onCompletion = ^(id result) {
//            self.forwardToDeviceView = YES;
//            self.device = result;
//            [self performSegueWithIdentifier:FromOverViewToDeviceViewSegue sender:nil];
//        };
    } else if([segue.identifier isEqualToString:FromOverViewToCreateDeviceSegue]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        CreateDeviceViewController *controller = (CreateDeviceViewController *)navigationController.topViewController;
        controller.shouldRegisterCurrentDevice = NO;
        controller.onCompletion = ^(id result) {
            self.forwardToDeviceView = YES;
            self.forwardedDevice = result;
            [self performSegueWithIdentifier:FromOverViewToDeviceViewSegue sender:nil];
        };
    }
}

@end