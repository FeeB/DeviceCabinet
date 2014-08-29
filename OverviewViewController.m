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
#import "TEDLocalization.h"
#import "ProfileViewController.h"

@interface OverviewViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, strong) Device *device;
@end

@implementation OverviewViewController

NSString *FromOverViewToDeviceViewSegue = @"FromOverviewToDeviceView";
NSString * const FromProfileButtonToProfileSegue = @"FromProfileButtonToProfile";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showTitelForLogOutButton];
    
    [TEDLocalization localize:self];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.transform = CGAffineTransformMakeScale(2, 2);
    self.spinner.center = self.tableView.center;
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAllDevices];
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
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
        
    NSArray *array = [self.lists objectAtIndex:indexPath.section];
    if ([array[0] isKindOfClass:[Device class]]) {
        Device *cellDevice = [array objectAtIndex:indexPath.row];
        NSString *cellValue = cellDevice.deviceName;
        
        
        
        cell.textLabel.text = cellValue;
        
        if (cellDevice.image) {
            cell.imageView.image = cellDevice.image;
        } else {
            UIImage *image = [UIImage imageNamed:@"placeholder_image.png"];
            cell.imageView.image = image;
        }
         
    } else {
        cell.textLabel.text = array[0];
        cell.userInteractionEnabled = NO;
    }
    
    
    return cell;
}

//On click on one cell the device view will appear
- (IBAction)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.userIsLoggedIn) {
        [self performSegueWithIdentifier:FromOverViewToDeviceViewSegue sender:nil];
    } else {
        [self performSegueWithIdentifier:LogoutButtonSegue sender:self];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FromOverViewToDeviceViewSegue]) {
        DeviceViewController *controller = (DeviceViewController *)segue.destinationViewController;
        NSArray *array = [self.lists objectAtIndex:self.tableView.indexPathForSelectedRow.section];
        controller.deviceObject = [array objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.lists.count == 2) {
        return section == 0 ? NSLocalizedString(@"SECTION_BOOKED_DEVICES", nil) : NSLocalizedString(@"SECTION_FREE_DEVICES", nil);
    } else {
        NSArray *array = self.lists[0];
        if ([array[0] isKindOfClass:[Device class]]) {
            NSArray *devices = self.lists[0];
            if (devices.count > 0 && ((Device *)devices[0]).isBooked) {
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
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    [cloudManager fetchDevicesWithCompletionHandler:^(NSArray *deviceObjects, NSError *error) {
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
            
            [self.tableView reloadData];
        }
    }];
}

- (void)showTitelForLogOutButton {
    if (self.userIsLoggedIn) {
        [self.logOutButton setTitle:NSLocalizedString(@"BUTTON_LOGOUT", nil)];
    } else {
        [self.logOutButton setTitle:NSLocalizedString(@"BUTTON_LOGIN", nil)];
    }
}


- (IBAction)logOut {
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    [userDefaults resetUserDefaults];
    [self performSegueWithIdentifier:LogoutButtonSegue sender:self];
}

- (IBAction)profileButton {
    if (self.userIsLoggedIn) {
        [self performSegueWithIdentifier:FromProfileButtonToProfileSegue sender:self];
    } else {
        [self performSegueWithIdentifier:LogoutButtonSegue sender:self];
    }
    
}

- (void)updateTable {
    [self getAllDevices];
    [self.refreshControl endRefreshing];
}


@end
