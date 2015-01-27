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
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "DecisionViewController.h"
#import "CreateDeviceViewController.h"
#import "RESTApiClient.h"
#import "RESTApiErrorMapper.h"
#import "UIDevice-Hardware.h"
#import "UserDefaultsWrapper.h"
#import "Device.h"

@interface OverviewViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *localDevice;
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
    
    self.navigationItem.hidesBackButton = YES;
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
    [refreshControl addTarget:self action:@selector(getAllDevices) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.device = [Injector.sharedInstance.userDefaultsWrapper getLocalDevice];
    [self checkForSystemVersionUpdate];
    [self handleIfAppRunsOnTestDevice];
    [self getAllDevices];
}

- (void)handleIfAppRunsOnTestDevice {
    if (self.device) {
        self.localDevice = [[NSMutableArray alloc] init];
        [self.localDevice addObject:self.device];
        if (self.segmentedControl.numberOfSegments == 2) {
            [self.segmentedControl insertSegmentWithTitle:NSLocalizedString(@"SECTION_ACTUAL_DEVICE", nil) atIndex:0 animated:NO];
            self.segmentedControl.selectedSegmentIndex = 0;
            self.currentList = self.localDevice;
        }
    }
}

- (void)fillListBasedOnSegmentedControl {
    if (self.segmentedControl.selectedSegmentIndex == 0 + (self.device ? 1 : 0)) {
        self.currentList = self.availableDevices;
    } else if (self.segmentedControl.selectedSegmentIndex == 1 + (self.device ? 1 : 0)) {
        self.currentList = self.bookedDevices;
    } else {
        self.currentList = self.localDevice;
    }
    [self.tableView reloadData];
}

- (IBAction)sectionDidChange:(UISegmentedControl *)segmentedControl {
    [self fillListBasedOnSegmentedControl];
}

- (void)checkForSystemVersionUpdate {
    if (self.device) {
        [Injector.sharedInstance.restApiClient fetchDeviceWithDevice:self.device completionHandler:^(Device *device, NSError *error) {
            if (error) {
                if (!error.code == [RESTApiErrorMapper itemNotFoundInDatabaseError].code) {
                    [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                               message:error.localizedRecoverySuggestion
                                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                }
            } else {
                if (![device.systemVersion isEqualToString:[[UIDevice currentDevice] systemVersion]]) {
                    self.device.systemVersion = [[UIDevice currentDevice] systemVersion];
                    [Injector.sharedInstance.userDefaultsWrapper setLocalDevice:device];
                    [Injector.sharedInstance.restApiClient updateSystemVersion:self.device completionHandler:nil];
                    [self getAllDevices];
                }
            }
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

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
    UILabel *cellLabelSystemVersion = (UILabel *)[cell viewWithTag:500];
    UILabel *cellLabelBookedByPerson = (UILabel *)[cell viewWithTag:300];
    UIImageView *cellUserPhoto = (UIImageView *) [cell viewWithTag:400];
    UIImageView *cellSystemVersionPhoto = (UIImageView *) [cell viewWithTag:600];
    
    Device *cellDevice = [self.currentList objectAtIndex:indexPath.row];
    cellLabel.text = cellDevice.deviceName;
    cellLabelDeviceType.text = cellDevice.deviceType;
    cellLabelSystemVersion.text = cellDevice.systemVersion;
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    [imageView setImageWithURL:cellDevice.imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    if (cellDevice.bookedByPerson) {
        cellLabelBookedByPerson.text = cellDevice.bookedByPersonFullName;
        cellUserPhoto.hidden = NO;
    } else {
        cellLabelBookedByPerson.text = @"";
        cellUserPhoto.hidden = YES;
    }
    
    if ([cellDevice.type isEqualToString:@"iPhone"] || [cellDevice.type isEqualToString:@"iPad"]) {
        [cellSystemVersionPhoto setImage:[UIImage imageNamed:@"apple.png"]];
    } else {
        [cellSystemVersionPhoto setImage:[UIImage imageNamed:@"android.png"]];
    }

    return cell;
}

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
    [Injector.sharedInstance.restApiClient deleteDevice:device completionHandler:^(NSError *error) {
        if (error) {
            [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                       message:error.localizedRecoverySuggestion
                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        } else {
            // Handle case that the current device was deleted
            if (device.deviceUdId && [device.deviceUdId isEqualToString:self.device.deviceUdId]) {
                [Injector.sharedInstance.userDefaultsWrapper reset];
                [Injector.sharedInstance.keyChainWrapper reset];
                self.device = nil;
                [self.segmentedControl removeSegmentAtIndex:0 animated:NO];
                
                if (self.currentList == self.localDevice) {
                    self.currentList = self.availableDevices;
                    [self.segmentedControl setSelectedSegmentIndex:0];
                }
            }
        }
        [self getAllDevices];
    }];
}

- (void)getAllDevices {
    [self.spinner startAnimating];
    
    [Injector.sharedInstance.restApiClient fetchDevicesWithCompletionHandler:^(NSArray *deviceObjects, NSError *error) {
        [self.spinner stopAnimating];
        [self.refreshControl endRefreshing];

        if (error) {
            [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                       message:error.localizedRecoverySuggestion
                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            
            [self.segmentedControl setSelectedSegmentIndex:0];
            [self fillListBasedOnSegmentedControl];
            
            if (self.currentList[0] == self.device) {
                self.localDevice = nil;
                [self.segmentedControl removeSegmentAtIndex:0 animated:NO];
                self.currentList = self.availableDevices;
                [self.segmentedControl setSelectedSegmentIndex:0];
                [self fillListBasedOnSegmentedControl];
            }
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
            
            [self handleIfAppRunsOnTestDevice];
            [self fillListBasedOnSegmentedControl];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FromOverViewToDeviceViewSegue]) {
        DeviceViewController *controller = (DeviceViewController *)segue.destinationViewController;
        controller.automaticReturn = self.automaticReturn;
        self.automaticReturn = NO;
        if (self.forwardToDevice) {
            controller.device = self.forwardToDevice;
            self.forwardToDevice = nil;
        } else {
            controller.device = [self.currentList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        }
    } else if([segue.identifier isEqualToString:FromOverViewToCreateDeviceSegue]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        CreateDeviceViewController *controller = (CreateDeviceViewController *)navigationController.topViewController;
        controller.shouldRegisterLocalDevice = NO;
        controller.onCompletion = ^(id result) {
            self.forwardToDevice = result;
            [self performSegueWithIdentifier:FromOverViewToDeviceViewSegue sender:nil];
        };
    }
}

@end
