//
//  OverviewViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 04.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "OverviewViewController.h"
#import "DeviceViewController.h"
#import "LogInViewController.h"
#import "UserDefaults.h"
#import "UIdGenerator.h"
#import "TEDLocalization.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "DecisionViewController.h"
#import "CreateDeviceViewController.h"

#import "HandleBeacon.h"

@interface OverviewViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, strong) Device *device;
@property (nonatomic, strong) NSMutableData *downloadedData;
@end

@implementation OverviewViewController

NSString * const FromOverViewToDeviceViewSegue = @"FromOverviewToDeviceView";
NSString * const FromProfileButtonToProfileSegue = @"FromProfileButtonToProfile";
NSString * const FromOverViewToRegisterSegue = @"FromOverViewToRegister";
NSString * const FromOverViewToCreateDeviceSegue = @"FromOverViewToCreateDevice";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HandleBeacon *handleBeacon = [[HandleBeacon alloc] init];
    [handleBeacon searchForBeacon];
    
    [TEDLocalization localize:self];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.transform = CGAffineTransformMakeScale(2, 2);
    self.spinner.center = self.tableView.center;
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self performSelector:@selector(checkDeviceIsRegistered)
               withObject:nil
               afterDelay:1.0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAllDevices];
}

- (void)checkDeviceIsRegistered {
    if ([self firstLaunch]) {
        [self performSegueWithIdentifier:FromOverViewToRegisterSegue sender:nil];
    }
}

- (BOOL)firstLaunch {
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    NSString *userType = [userDefaults getUserType];
    
    if (userType) {
        return NO;
    } else {
        return YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.lists.count;
}

//standard methods for tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [self.lists objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
    NSArray *array = [self.lists objectAtIndex:indexPath.section];
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *cellLabelDeviceType = (UILabel *)[cell viewWithTag:200];
    if ([array[0] isKindOfClass:[Device class]]) {
        Device *cellDevice = [array objectAtIndex:indexPath.row];
        cellLabel.text = cellDevice.deviceName;
        cellLabelDeviceType.text = cellDevice.deviceType;
        
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
        [imageView setImageWithURL:cellDevice.imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_image.png"]];
    } else {
        cellLabel.text = array[0];
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}

//On click on one cell the device view will appear
- (IBAction)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:FromOverViewToDeviceViewSegue sender:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.lists.count == 2) {
        return section == 0 ? NSLocalizedString(@"SECTION_BOOKED_DEVICES", nil) : NSLocalizedString(@"SECTION_FREE_DEVICES", nil);
    } else {
        NSArray *array = self.lists[0];
        if ([array[0] isKindOfClass:[Device class]]) {
            NSArray *devices = self.lists[0];
            if (devices.count > 0 && ((Device *)devices[0]).isBookedByPerson) {
                return NSLocalizedString(@"SECTION_BOOKED_DEVICES", nil);
            } else {
                return NSLocalizedString(@"SECTION_FREE_DEVICES", nil);
            }
        } else {
            return NSLocalizedString(@"SECTION_ERROR", nil);
        }
    }
}

//get all devices for the device overview
- (void)getAllDevices {
    [self.spinner startAnimating];

    [AppDelegate.dao fetchDevicesWithCompletionHandler:^(NSArray *deviceObjects, NSError *error) {
        [self.spinner stopAnimating];
        if (error) {
            self.lists = [[NSMutableArray alloc] init];
            NSMutableArray *errorMessage = [[NSMutableArray alloc] init];
            [errorMessage addObject:error.localizedRecoverySuggestion];
            [self.lists addObject:errorMessage];
            
            [self.tableView reloadData];
            
            [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                       message:error.localizedRecoverySuggestion
                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        } else {
            self.lists = [[NSMutableArray alloc] init];
            NSMutableArray *bookedDevices = [[NSMutableArray alloc] init];
            NSMutableArray *freeDevices = [[NSMutableArray alloc] init];
            
            for (Device *device in deviceObjects){
                if (device.isBookedByPerson) {
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
            [self.tableView reloadData];
        }
    }];
}

- (void)updateTable {
    [self getAllDevices];
    [self.refreshControl endRefreshing];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FromOverViewToDeviceViewSegue]) {
        DeviceViewController *controller = (DeviceViewController *)segue.destinationViewController;
        if (self.forwardToDeviceView) {
            controller.deviceObject = self.device;
        } else {
            NSArray *array = [self.lists objectAtIndex:self.tableView.indexPathForSelectedRow.section];
            controller.deviceObject = [array objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        }
    } else if([segue.identifier isEqualToString:FromOverViewToRegisterSegue]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        DecisionViewController *controller = (DecisionViewController *)navigationController.topViewController;
        
        controller.onCompletion = ^(id result) {
            self.forwardToDeviceView = YES;
            self.device = result;
            [self performSegueWithIdentifier:FromOverViewToDeviceViewSegue sender:nil];
        };
    } else if([segue.identifier isEqualToString:FromOverViewToCreateDeviceSegue]) {
        CreateDeviceViewController *controller = (CreateDeviceViewController *)segue.destinationViewController;
        controller.onCompletion = ^(id result) {
            self.forwardToDeviceView = YES;
            self.device = result;
            [self performSegueWithIdentifier:FromOverViewToDeviceViewSegue sender:nil];
        };
    }
}

@end
